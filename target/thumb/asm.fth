\ Copyright 2017 Lars Brinkhoff

\ Assembler for ARM Thumb2.

\ Adds to FORTH vocabulary: ASSEMBLER CODE ;CODE.
\ Creates ASSEMBLER vocabulary with: END-CODE and Thumb-1 opcodes.

\ This will become a cross assembler if loaded with a cross-compiling
\ vocabulary at the top of the search order.

\ Conventional prefix syntax: "<source> <destination> <opcode>,".
\ Addressing modes:
\ - immediate: "n #"
\ - pc-relative: n
\ - register: <reg>
\ - indirect: "<reg> )"
\ - indexed with immediate offset: "n <reg> )#"
\ - indexed with register offset: "<reg> <reg> +)"

require search.fth
also forth definitions
require lib/common.fth

vocabulary assembler

base @  hex

\ This constant signals that an operand is not a direct address.
deadbeef constant -addr

\ Assembler state.
variable opcode
variable shift
variable +op
defer imm-op
defer reg

\ Set opcode.
: opcode!   3@ drop >r opcode ! ;
: op+!   +op @ opcode +! ;
: rd!   opcode 0007 !bits ;
: rdh!   4 lshift 0080 and ?dup if opcode 0080 !bits then ;
: rs!   3 lshift opcode 0038 !bits ;
: rsh!   3 lshift 0040 and ?dup if opcode 0040 !bits then ;
: ro!   6 lshift opcode 01C0 !bits ;
: ri!   8 lshift opcode 0700 !bits ;
: !w   00200000 opcode +! ;
: imm5!   6 lshift opcode 07C0 !bits ;
: imm8!   opcode 00FF !bits ;
: imm9!   opcode 01FF !bits ;
: imm11!   opcode 07FF !bits ;
: shift!   shift ! ;

\ Access instruction fields.
: opcode@   opcode @ ;

\ Possibly use a cross-compiling vocabulary to access a target image.
previous definitions

\ Write instruction fields to memory.
: w,   dup c, 8 rshift c, ;
: w@   dup c@ swap 1+ c@ 8 lshift + ;
: w!   2dup c!  swap 8 rshift  swap 1+ c! ;
: offset8!   dup w@ FF00 and rot 00FF and + swap w! ;
: offset11!   dup w@ F800 and rot 07FF and + swap w! ;
: opcode,   opcode@ w, ;
: callh,   12 rshift 07FF and F000 + w, ;
: pc-   here - ;
: relative   pc- 4 - 1 rshift ;

also forth definitions

\ Implements addressing modes: register, indirect, postincrement,
\ predecrement, and absolute.
: !ri   ['] ri! is reg ;
: reg3   ro! ;
: !reg3   ['] reg3 is reg ;
: reg2   dup rs! rsh!  !reg3 ;
: !reg2   ['] reg2 is reg ;
: reg1   dup rd! rdh!  !reg2 ;
: ind#   rs!  shift @ rshift imm5!  1000 opcode +! ;
: indr   rs! 2drop ro! ;
: indsp   4000 opcode +!  2 rshift imm8! ;
: addr   opcode @ ri!  pc- 2 - 2 rshift imm8!  -1000 opcode +! ;

\ Implements addressing mode: immediate.
: !imm5   ['] imm5! is imm-op ;
: !imm8   ['] imm8! is imm-op ;
: !imm9   ['] imm9! is imm-op ;

\ Reset assembler state.
: 0reg   ['] reg1 is reg ;
: 0imm   !imm8 ;
: 0shift   2 shift ! ;
: 0x   0 +op ! ;
: 0asm   0reg 0imm 0shift 0x ;

\ Process one operand.  All operands except a direct address
\ have the stack picture ( n*x xt -addr ).
: addr?   dup -addr <> ;
: op   addr? if addr else drop execute then ;

\ Define instruction formats.
: instruction, ( a -- ) opcode! opcode, 0asm ;
: mnemonic ( u a "name" -- ) create ['] noop 3,  does> instruction, ;
: format:   create ] !csp  does> mnemonic ;
: immediate:   ' latestxt >body ! ;

\ Instruction formats.
format: 0op ;
format: 1op   !reg2 op ;
format: multi   !imm9 op ;
format: 2op   op op ;
format: byte   0 shift!  op op  op+! ;
format: half   1 shift!  op op  op+! op+! ;
format: 3op   !imm5 0reg op op op ;
format: branch8   relative imm8! ;
format: branch11   relative imm11! ;
format: call   relative dup callh, imm11! ;

\ Define registers.
: reg:   create dup 000F and , 1+  does> @ ['] reg -addr ;

\ Instruction mnemonics.
previous also assembler definitions

\ Cortex-M0 instruction set:  [32-BIT]
\ adcs, add, adds, adr, ands, asrs, bcc, bics, bkpt, [BL], blx, bx, cmn,
\ cmp, cpsid, cpsie, [DMB], [DSB], eors, [ISB], ldm, ldr, ldrb, ldrh, ldrsb,
\ ldrsh, lsls, lsrs, mov, movs, [MRS], [MSR], muls, mvns, nop, orrs, pop,
\ push, rev, rev16, revsh, rors, rsbs, sbcs, sev, stm, str, strb, strh,
\ sub, subs, svc, sxtb, sxth, tst, uxtb, uxth, wfe, wfi

0000 3op lsli,
0800 3op lsri,
1000 3op asri,
1800 3op add,
1A00 3op sub,
\ 1C00 add,
\ 1E00 sub,
2000 2op movi,
2800 2op cmpi,
3000 2op addi,
3800 2op subi,
4000 2op and,
4040 2op eor,
4080 2op lsl,
40C0 2op lsr,
4100 2op asr,
4140 2op adc,
4180 2op sbc,
41C0 2op ror,
4200 2op tst,
4240 2op neg,
4280 2op cmp,
42C0 2op cmn,
4300 2op orr,
4340 2op mul,
4380 2op bic,
43C0 2op mvn,
\ 4400 addh,
\ 4500 cmph,
4600 2op movh,
4700 1op bx,
4780 1op blx,
5000 2op str,
5800 2op ldr,

5400 byte strb,	\ 7000	1C00 -
5C00 byte ldrb,	\ 7800

5200 half strh,	\ 8000	2E00 -
5A00 half ldrh,	\ 8800

5600 2op ldrsb,
5E00 2op ldrsh,
\ A000 adr,
\ A800 add, \ sp + reg
B000 1op addsp,
\ B080 sub, \ sp + #
\ B100 cbz,
B200 2op sxth,
B240 2op sxtb,
B280 2op uxth,
B2C0 2op uxtb,
B400 multi push,
\ B660 cps,
\ B900 cbnz,
\ BA00 rev,
\ BA40 rev16,
\ BAC0 revsh,
BC00 multi pop,
BE00 1op bkpt,
\ BF00 it,
\ BF10 yield,
\ BF20 wfe,
\ BF30 wfi,
\ BF40 sev,
\ C800 stm,
\ C800 ldm,
D000 branch8 beq,
D100 branch8 bne,
D200 branch8 bcs,
D300 branch8 bcc,
D400 branch8 bmi,
D500 branch8 bpl,
D600 branch8 bvs,
D700 branch8 bvc,
D800 branch8 bhi,
D900 branch8 bls,
DA00 branch8 bge,
DB00 branch8 blt,
DC00 branch8 bgt,
DD00 branch8 ble,
DE00 1op udf,
DF00 1op svc,
E000 branch11 b,
F800 call bl,
\ E8000000 stm,
\ E8000000 ldm,
\ E8400000 \ load/store dual or exclusive, table branch
\ EA000000 \ data processing
\ EC000000 \ coprocessor
\ F0000000 and,
\ F0000F00 tst,
\ F0008000 b,
\ F000D000 bl,
\ F0400000 bic,
\ F0800000 orr,
\ F0800F00 mov,
\ F0C00000 orn,
\ F0C00F00 mvn,
\ F1000000 eor,
\ F1000F00 teq,
\ F2000000 add,
\ F2000F00 cmn,
\ F2800000 adc,
\ F2C00000 sbc,
\ F3400000 sub,
\ F3400F00 cmp,
\ F3800000 rsb,
\ F7008000 msr,
\ F7608000 mrs,
\ F8000000 ldr,
\ F8000000 \ store single data item
\ F8100000 ldrb,
\ F8300000 ldrh,
\ F8500000 ldr,
\ F8700000 \ undefined
\ FA000000 \ data processing
\ FB000000 mul,
\ FB000000 mla,
\ FB800000 mull,
\ FC000000 \ coprocessor

\ Addressing mode syntax: immediate, indirect, and indexed.
: #   ['] imm-op -addr  !ri ;
: )#   2drop ['] ind# -addr  1000 +op ! ;
: )   2>r 0 swap 2r> )# ;
: +)   2drop ['] indr -addr ;
: sp)   ['] indsp -addr  !ri ;

\ Register names.
0
reg: r0  reg: r1  reg: r2  reg: r3  reg: r4  reg: r5  reg: r6  reg: r7
reg: r8  reg: r9  reg: r10  reg: r11  reg: r12  reg: sp  reg: lr  reg: pc
drop

\ Register sets.
: {r0}   01 # ;
: {r6}   40 # ;
: {lr}   100 # ;
: {pc}   {lr} ;
: {r0-r7,   FF # ;
: lr}   rot 100 or -rot ;
: pc}   lr} ;

\ Aliases.
: mov,   2>r 2>r 2>r 0 # 2r> 2r> 2r> lsli, ;
: nop,  r8 r8 movh, ;

\ Resolve jumps.
: >mark8   ['] offset8! here 2 - ;
: >mark11   ['] offset11! here 2 - ;
: >resolve   dup pc- 4 + negate 2/ swap rot execute ;

\ Unconditional jumps.
: label   here >r get-current ['] assembler set-current r> constant set-current ;
: begin,   here ;
: again,   b, ;
: ahead,   here b, >mark11 ;
: then,   >resolve ;

\ Conditional jumps.
: 0=,   ['] bne, ;
: 0<,   ['] bge, ;
: 0<>,   ['] beq, ;
: if,   0 swap execute >mark8 ;
: until,   execute ;

: else,   ahead, 2swap then, ;
: while,   >r if, r> ;
: repeat,   again, then, ;

\ Runtime for ;CODE.  CODE! is defined elsewhere.
: (;code)   r> code! ;

\ Enter and exit assembler mode.
: start-code   also assembler 0asm ;
: end-code     previous ;

also forth base ! previous

previous definitions also assembler

\ Standard assembler entry points.
: code    parse-name header, ?code, reveal start-code  ;
: ;code   postpone (;code) reveal postpone [ ?csp start-code ; immediate

0asm
previous

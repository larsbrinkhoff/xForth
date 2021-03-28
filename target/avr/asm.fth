\ Copyright 2016 Lars Brinkhoff

\ Assembler for AVR.

\ Adds to FORTH vocabulary: ASSEMBLER CODE ;CODE.
\ Creates ASSEMBLER vocabulary with: END-CODE and AVR opcodes.

\ This will become a cross assembler if loaded with a cross-compiling
\ vocabulary at the top of the search order.

\ Conventional prefix syntax: "<source> <destination> <opcode>,".
\ Addressing modes:
\ - immediate: "n #"
\ - absolute: n
\ - register: <reg>
\ - preincrement: -<index>
\ - postdecrement: <index>+
\ - indirect with offset: "n <index> )#"

require search.fth
also forth definitions
require lib/common.fth

vocabulary assembler

base @  hex

\ This constant signals that an operand is not a direct address.
deadbeef constant -addr

\ Assembler state.
variable opcode
variable word  defer ?word,
variable rd-mask
defer reg
defer idx
defer imm-op
defer addr

\ Set opcode.
: opcode!   3@ drop >r opcode ! ;
: field!   opcode swap !bits ;
: idx!   100F field! ;
: idx2   1 and opcode +! ;
: rd!   4 lshift rd-mask @ field! ;
: rn!   dup 000F field!  5 lshift 0200 field! ;
: imm!   dup 000F field!  4 lshift 0F00 field! ;
: wimm!   dup 000F field!  2 lshift 00C0 field! ;
: bit!   0007 field! ;
: io!   3 lshift 00F8 field! ;
: inout!   dup 000F field!  5 lshift 0600 field! ;
: disp!   dup 0003 field!  dup 5 lshift 0C00 field!  8 lshift 2000 field! ;
: ?lpm   opcode @ 9004 = if 95C8 opcode ! then ;


\ Access instruction fields.
: opcode@   opcode @ ;

\ Possibly use a cross-compiling vocabulary to access a target image.
previous definitions

\ Write instruction fields to memory.
: w,   dup c, 8 rshift c, ;
: w@   dup c@ swap 1+ c@ 8 lshift + ;
: w!   2dup c!  swap 8 rshift  swap 1+ c! ;
: opcode,   opcode@ w, ;
: pc-   here - 2 - ;
: offset!   dup w@ FF000000 and rot 00FFFFFF and + swap w! ;
: br!   over w@ FC07 and swap 2 lshift 03F8 and + swap w! ;
: jmp!   over w@ F000 and swap 1 rshift 0FFF and + swap w! ;

also forth definitions

: word,   word @ w, ;
: !word   word !  ['] word, is ?word, ;
: !jump   dup !word  dup 10 rshift 0001 field!  0D rshift 01F0 field! ;
: !rjump   pc- 1 rshift 0FFF field! ;
: !branch   pc- 2 lshift 03F8 field! ;

\ Implements addressing modes: register, indirect, postincrement,
\ predecrement, and absolute.
: reg2   rn! ;
: !reg2   ['] reg2 is reg ;
: reg1   rd! !reg2 ;
: wimm-op   wimm! ;
: imm-op   imm! ;

\ Reset assembler state.
: 0reg   ['] reg1 is reg ;
: 0w   ['] noop is ?word, ;
: 0rd   01F0 rd-mask ! ;
: 0idx   ['] idx! is idx ;
: 0imm   ['] imm! is imm-op ;
: 0addr   ['] io! is addr ;
: 0asm   0reg 0w 0rd 0idx 0imm 0addr ;

\ Process one operand.  All operands except a direct address
\ have the stack picture ( n*x xt -addr ).
: addr?   dup -addr <> ;
: op   addr? if addr else drop execute then ;
: disp   2drop idx! disp! ;

\ Define instruction formats.
: instruction, ( a -- ) opcode! opcode, ?word, 0asm ;
: mnemonic ( u a "name" -- ) create ['] noop 3,  does> instruction, ;
: format:   create ] !csp  does> mnemonic ;
: immediate:   ' latestxt >body ! ;

\ Instruction formats.
format: 0op ;
format: 1op   op ;
format: 2op   op op ;
format: ds   op !word ;
format: movw   0F0 rd-mask !  2>r >r 2>r 2/  2r> r> 2/ 2r>  op op ;
format: adiw   030 rd-mask !  ['] wimm! is imm-op  2>r 18 - 2/ 2r>  op op ;
format: lpm   ['] idx2 is idx  op op ?lpm ;
format: skip   ['] bit! is imm-op  op op ;
format: inout   ['] inout! is addr  op op ;
format: jump   !jump ;
format: rjump   !rjump ;
format: branch   !branch ;

\ Define registers
: reg:   create dup , 1+  does> @ ['] reg -addr ;
: index:   create ,  does> @ ['] idx -addr ;

\ Instruction mnemonics.
previous also assembler definitions

0000 0op nop,
0100 movw movw,
\ 0200 muls,
\ 0300 mulsu,
\ 0308 fmul,
\ 0380 fmuls,
\ 0388 fmulsu,
0400 2op cpc,
0800 2op sbc,
0C00 2op add,
1000 2op cpse,
1400 2op cp,
1800 2op sub,
1C00 2op adc,
2000 2op and,
2400 2op eor,
2800 2op or,
2C00 2op mov,
3000 2op cpi,
4000 2op sbci,
5000 2op subi,
6000 2op ori,
7000 2op andi,
8000 2op ldd,
8200 2op std,
9000 ds lds,
9000 2op ld,
9200 ds sts,
9200 2op st,
9004 lpm lpm,
9006 lpm elpm,
9204 1op xch,
9205 1op las,
9206 1op lac,
9207 1op lat,
900F 1op pop,
920F 1op push,
9400 1op com,
9401 1op neg,
9402 1op swap,
9403 1op inc,
9405 1op asr,
9406 1op lsr,
9407 1op ror,
9408 0op sec,
9418 0op sez,
9428 0op sen,
9438 0op sev,
9448 0op ses,
9458 0op seh,
9468 0op set,
9478 0op sei,
9488 0op clc,
9498 0op clz,
94A8 0op cln,
94B8 0op clv,
94C8 0op cls,
94D8 0op clh,
94E8 0op clt,
94F8 0op cli,
9508 0op ret,
9518 0op reti,
9588 0op sleep,
9598 0op break,
95A8 0op wdr,
95E8 0op spm,
9409 0op ijmp,
9419 0op eijmp,
9509 0op icall,
9519 0op eicall,
940A 1op dec,
\ 940B des,
940C jump jmp,
940E jump call,
9600 adiw adiw,
9700 adiw sbiw,
9800 skip cbi,
9900 skip sbic,
9A00 skip sbi,
9B00 skip sbis,
9C00 2op mul,
B000 inout in,
B800 inout out,
C000 rjump rjmp,
D000 rjump rcall,
E000 2op ldi,
F000 branch brcs,
F001 branch breq,
F002 branch brmi,
F003 branch brvs,
F004 branch brlt,
F005 branch brhs,
F006 branch brts,
F007 branch brie,
F400 branch brcc,
F401 branch brne,
F402 branch brpl,
F403 branch brvc,
F404 branch brge,
F405 branch brhc,
F406 branch brtc,
F407 branch brid,
\ F800 bld,
\ FA00 bst,
FC00 skip sbrc,
FE00 skip sbrs,

\ Addressing mode syntax.
: #   ['] imm-op -addr ;
: )#   ['] disp -addr ;

\ Register names.
0
reg: r0  reg: r1  reg: r2  reg: r3  reg: r4  reg: r5  reg: r6  reg: r7
reg: r8  reg: r9  reg: r10  reg: r11  reg: r12  reg: r13  reg: r14  reg: r15
reg: r16  reg: r17  reg: r18  reg: r19  reg: r20  reg: r21  reg: r22  reg: r23
reg: r24  reg: r25  reg: r26  reg: r27  reg: r28  reg: r29  reg: r30  reg: r31
drop

\ Index registers.
0000 index: z
1001 index: z+
1002 index: -z
0008 index: y
1009 index: y+
100A index: -y
100C index: x
100D index: x+
100E index: -x

\ Aliases
: clr,   3dup eor, ;
: lsl,   3dup add, ;
: rol,   3dup adc, ;

\ Resolve jumps.
: >mark-br   here 2 - ['] br! here ;
: >mark-jmp   here 2 - ['] jmp! here ;
: >resolve   here - negate swap execute ;

\ Unconditional jumps.
: label   here >r get-current ['] assembler set-current r> constant set-current ;
: begin,   here ;
: again,   rjmp, ;
: ahead,   0 rjmp, >mark-jmp ;
: then,   >resolve ;

\ Conditional jumps.
: 0=,   ['] brne, ;
: 0<,   ['] brge, ;
: 0<>,   ['] breq, ;
: if,   0 swap execute >mark-br ;
: until,   execute ;

: 3swap   >r rot >r 2swap 2r> >r -rot r> ;
: else,   ahead, 3swap then, ;
: while,  swap >r if, r> ;
: repeat,   again, then, ;

\ Runtime for ;CODE.  CODE! is defined elsewhere.
: (;code)   r> code! ;

\ Enter and exit assembler mode.
: start-code   also assembler 0asm ;
: end-code     align previous ;

also forth base ! previous

previous definitions also assembler

\ Standard assembler entry points.
: code    parse-name header, ?code, reveal start-code  ;
: ;code   postpone (;code) reveal postpone [ ?csp start-code ; immediate

0asm
previous

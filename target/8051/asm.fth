\ Copyright 2017 Lars Brinkhoff

\ Assembler for 8051.

\ Adds to FORTH vocabulary: ASSEMBLER CODE ;CODE.
\ Creates ASSEMBLER vocabulary with: END-CODE and 8081 opcodes.

\ This will become a cross assembler if loaded with a cross-compiling
\ vocabulary at the top of the search order.

\ Conventional prefix syntax: "<source> <destination> <opcode>,".
\ Addressing modes:
\ - immediate: "n #"
\ - absolute: n
\ - register: a, r<n>, dptr
\ - indirect: @<reg>

require search.fth
also forth definitions
require lib/common.fth

vocabulary assembler

base @  hex

\ This constant signals that an operand is not a direct address.
deadbeef constant -addr

\ Assembler state.
variable opcode
variable mode
variable data   defer ?data,
defer !data8

\ Set opcode.
: opcode!   3@ drop >r opcode ! ;
: !mode   mode +! ;

\ Access instruction fields.
: opcode@   opcode @ mode @ + ;
: mode@   mode @ ;
: data@   data @ ;

\ Possibly use a cross-compiling vocabulary to access a target image.
previous

\ Write instruction fields to memory.
: w,   dup 8 rshift c, c, ;
: w!   over 8 rshift over c! 1+ c! ;
: opcode,   opcode@ c, ;
: data8,   data@ c, ;
: data16,   data@ w, ;
: pc-   here - 2 - ;

also forth

: range-error   ." Jump range error: " source type abort ;
: ?range   dup -80 80 within 0= if range-error then ;

\ Set operand data.
: !data8again   data @ 8 lshift + data !  ['] data16, is ?data, ;
: !data81+   !data8again  1 !mode ;
: !data8stm    8 lshift data @ + data !  ['] data16, is ?data, ;
: (!data8)   data !  ['] data8, is ?data,  ['] !data8again is !data8 ;
: !jump   dup !data8  3 rshift E0 and opcode +! ;
: !data16   data !  ['] data16, is ?data, ;

\ Implements addressing modes.
: imm-op   04 !mode !data8 ;
: accumulator   04 !mode ;
: absolute   05 !mode !data8 ;
: indirect   !mode ;
: reg   !mode ;
: movx-dptr   4 !mode ;
: mov-dptr   -4 !mode  ['] !data16 is !data8 ;

\ Reset assembler state.
: 0mode   0 mode ! ;
: 0data   ['] noop is ?data,  ['] (!data8) is !data8 ;
: 0op   0 opcode ! ;
: 0asm   0mode 0data 0op ;

\ Process one operand.  All operands except a direct address
\ have the stack picture ( n*x xt -addr ).
: addr?   dup -addr <> ;
: op   addr? if absolute else drop execute then ;

\ Define instruction formats.
: instruction,   opcode! opcode, ?data, 0asm ;
: mnemonic ( u a "name" -- ) create ['] noop 3,  does> instruction, ;
: format:   create ] !csp  does> mnemonic ;

\ Instruction formats.
format: 0op ;
format: 1op   op ;
format: 2op   op op ;
format: mem   op ['] !data81+ is !data8 op -7 !mode ;
format: movi   op op -4 !mode ;
format: movx   op -4 !mode ;
format: stm   op ['] !data8stm is !data8 op -5 !mode ;
format: ldm   op op -5 !mode ;
format: jump   !jump ;
format: long   !data16 ;
format: relative   pc- ?range !data8 ;

\ Define registers
: reg:   create dup , 1+  does> @ ['] reg -addr ;

\ Instruction mnemonics.
previous also assembler definitions

00 0op nop,
00 1op inc,
01 jump ajmp,
02 long ljmp,
03 0op rr,
\ 10 jbc,
10 1op dec,
11 jump acall,
12 long lcall,
13 0op rrc,
\ 20 jb,
20 1op add,
22 0op ret,
23 0op rl,
\ 30 jnb,
30 1op addc,
32 0op reti,
33 0op rlc,
40 relative jc,
40 1op orl,
40 mem orlm,
50 relative jnc,
50 1op anl,
50 mem anlm,
60 relative jz,
60 1op xrl,
60 mem xrlm,
70 relative jnz,
70 movi movi,
\ 72 orl,
73 0op jmp,
80 relative sjmp,
80 stm stm,
\ 82 anl,
\ 83 movc,
84 0op div,
90 2op mov,
90 1op subb,
\ 92 mov,
\ 93 movc,
\ A0 orl,
A0 ldm ldm,
\ A3 inc,
A4 0op mul,
\ A5 (reserved)
\ B0 anl, 
\ B0 cjne,
\ B2 cpl,
\ B3 cpl,
BB 1op push,
C0 1op xch,
\ C2 clr,
\ C3 clr,
C4 0op swap,
CB 1op pop,
\ D0 djnz,
D0 1op xchd,
\ D2 setb,
\ D3 setb,
D4 0op da,
E0 1op lda,
E0 movx xlda,
E0 1op clr,
F0 1op sta,
F0 movx xsta,
F0 1op cpl,

\ Addessing mode syntax.
: #     ['] imm-op -addr ;
: a     ['] accumulator -addr ;
: @r0   06 ['] indirect -addr ;
: @r1   07 ['] indirect -addr ;
: @dptr   ['] movx-dptr -addr ;
: dptr    ['] mov-dptr -addr ;

\ Register names.
08
reg: r0  reg: r1  reg: r2  reg: r3
reg: r4  reg: r5  reg: r6  reg: r7
drop

\ Aliases

\ Resolve jumps.
: >mark   here 1- here ;
: long?   dup 7F > over -80 < or ;
: long!   1- 02 swap c!+ here swap w! ;
: >resolve   here swap - long? if drop long! else swap c! then ;

\ Special function registers.
81 constant sp
82 constant dpl
83 constant dph
D0 constant psw
E0 constant acc
F0 constant b

\ Unconditional jumps.
: label   here >r get-current ['] assembler set-current r> constant set-current ;
: begin,   here ;
: again,   sjmp, ;
: ahead,   here sjmp, >mark ;
: then,   >resolve ;

\ Conditional jumps.
: 0=,   ['] jnz, ;
: 0<>,   ['] jz, ;
: cs,   ['] jnc, ;
: if,   here swap execute >mark ;
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

\ Copyright 2017 Lars Brinkhoff

\ Assembler for PDP-8.

\ Adds to FORTH vocabulary: ASSEMBLER CODE ;CODE.
\ Creates ASSEMBLER vocabulary with: END-CODE and PIC opcodes.

\ This will become a cross assembler if loaded with a cross-compiling
\ vocabulary at the top of the search order.

\ Conventional prefix syntax: "<operand> <opcode>,".
\ Addressing modes:
\ - absolute: n
\ - indirect: n )
\ - literal: n #

require search.fth
: cell/   cell / ;
also forth definitions
require lib/common.fth

vocabulary assembler

base @  octal

\ This constant signals that an operand is not a direct address.
-124 constant -addr

\ Assembler state.
variable opcode

\ Set opcode.
: opcode!   3@ drop >r opcode ! ;
: field!   opcode swap !bits ;
: -z   -1 0200 field! ;
: !z   0 0200 field! ;
: !i   -1 0400 field! ;
: z?   dup 0200 u< ;
: ?z   z? if !z else -z then ;
: addr   ?z  0177 field! ;
: indirect   !i addr ;

\ Access instruction fields.
: opcode@   opcode @ ;

\ Literal pool.
variable lit
: 0lit   200 lit ! ;
0lit
: lit+   -1 lit +! ;
: lit@   lit @ ;

\ Possibly use a cross-compiling vocabulary to access a target image.
previous definitions

\ Write instruction fields to memory.
: opcode,   opcode@ , ;
: indirect?   dup @ 0400 and ;
: jmp!   indirect? if @ 177 and cells else swap 0177 and swap then +! ;

\ Merge two consecutive instructions.
: +,   cell negate allot  here @  here cell - @ or  here cell - ! ;

\ Store a literal and return its address.
: >l   here cell/ -200 and + cells ;
: 'lit   lit@ >l ;
: +lit   lit+ 'lit ! 'lit cell/ ;
: more?   dup 200 < ;
: different?   2dup >l @ <> ;
: >lit ( x -- a )
   lit@ begin more? while different? while 1+ repeat
   nip >l cell/ else drop +lit then ;

\ Advance to next page boundary.
: #left   lit@ here cell/ 177 and - ;
: page   0lit  #left cells allot ;
: ?page   #left 20 < if page then ;

also forth definitions

\ Reset assembler state.
: 0asm ;

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
format: 1op   op ;
format: 2op   op op ;

\ Instruction mnemonics.
previous also assembler definitions

0000 1op and,
1000 1op tad,
2000 1op isz,
3000 1op dca,
4000 1op jms,
5000 1op jmp,

6000 2op iot,
6001 0op ion,
6002 0op iof,

7000 1op opr,
7001 0op iac,
7002 0op bsw,
7004 0op ral,
7006 0op rtl,
7010 0op rar,
7012 0op rtr,
7020 0op cml,
7040 0op cma,
7041 0op cia,
7100 0op cll,
7200 0op cla,
7402 0op hlt,
7403 0op scl,
7404 0op osr,
7405 0op muy,
7407 0op dvi,
7411 0op nmi,
7413 0op shl,
7415 0op asr,
7417 0op lsr,
7420 0op snl,
7421 0op mql,
7440 0op sza,
7441 0op sca,
7410 0op skp,
7430 0op szl,
7450 0op sna,
7500 0op sma,
7501 0op mqa,
7510 0op spa,
7621 0op cam,

\ Addressing mode syntax.
: )   ['] indirect -addr ;
: #i   >lit ) ;
: #   >lit ;
: +#   0 +lit ) ;

\ Aliases.
: tca,   cma, iac, +, ;
: stl,   cll, cml, +, ;
: nop,   0 opr, ;

\ Register names.

\ Resolve jumps.
: >mark   here cell - ;
: >resolve   here cell/ swap jmp! ;

\ Unconditional jumps.
: label   here >r get-current ['] assembler set-current r> constant set-current ;
: begin,   here cell/ ;
: again,   jmp, ;
: ahead,   200 jmp, >mark ;
: then,   >resolve ;

\ Conditional jumps.
: zero   sza, jmp, ;
: less   sma, jmp, ;
: nonzero   sna, jmp, ;
: link?   snl, jmp, ;
: 0=,   ['] zero ;
: 0<,   ['] less ;
: 0<>,   ['] nonzero ;
: l0<>,   ['] link? ;
: if,   200 swap execute >mark ;
: until,   execute ;

: else,   ahead, swap then, ;
: while,   >r if, r> ;
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

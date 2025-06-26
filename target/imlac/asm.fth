\ Copyright 2025 Lars Brinkhoff

\ Assembler for IMLAC PDS-1.

\ Adds to FORTH vocabulary: ASSEMBLER CODE ;CODE.
\ Creates ASSEMBLER vocabulary with: END-CODE and IMLAC PDS-1 opcodes.

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
: !i   -1 100000 field! ;
: addr    3777 field! ;
: indirect   !i addr ;
: #iot   777 field! ;
: #bits   3 field! ;

\ Access instruction fields.
: opcode@   opcode @ ;

\ Literal pool.
variable lit
: 0lit   2000 lit ! ;
0lit
: lit+   -1 lit +! ;
: lit@   lit @ ;

\ Possibly use a cross-compiling vocabulary to access a target image.
previous definitions

\ Write instruction fields to memory.
: opcode,   opcode@ , ;
: indirect?   dup @ 100000 and ;
: jmp!   indirect? if @ 3777 and cells else swap 3777 and swap then +! ;

\ Merge two consecutive instructions.
: +,   cell negate allot  here @  here cell - @ or  here cell - ! ;

\ Store a literal and return its address.
: >l   here cell/ -2000 and + cells ;
: 'lit   lit@ >l ;
: +lit   lit+ 'lit ! 'lit cell/ ;
: more?   dup 2000 < ;
: different?   2dup >l @ <> ;
: >lit ( x -- a )
   lit@ begin more? while different? while 1+ repeat
   nip >l cell/ else drop +lit then ;

\ Advance to next page boundary.
: #left   lit@ here cell/ 3777 and - ;
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

\ Instruction mnemonics.
previous also assembler definitions

000000 1op opr,
004000 1op law,
104000 1op lwc,
010000 1op jmp,
\ 014000
020000 1op dac,
024000 1op xam,
030000 1op isz,
034000 1op jms,
\ 040000
044000 1op and,
050000 1op ior,
054000 1op xor,
060000 1op lac,
064000 1op add,
070000 1op sub,
074000 1op sam,

000000 0op hlt,
100000 0op nop,
100001 0op cla,
100002 0op cma,
100003 0op sta,
100004 0op iac,
100005 0op coa,
100006 0op cia,
100010 0op cll,
100011 0op cal,
100020 0op cml,
100030 0op stl,
100040 0op oda,
100041 0op lda,

003000 1op ral,   : ral, ['] #bits -addr ral, ;
003020 1op rar,   : rar, ['] #bits -addr rar, ;
003040 1op sal,   : sal, ['] #bits -addr sal, ;
003060 1op sar,   : sar, ['] #bits -addr sar, ;
003100 0op don,

002001 0op asz,
102001 0op asn,
002002 0op asp,
102002 0op asm,
002004 0op lsz,
102004 0op lsn,
002010 0op dsf,
102010 0op dsn,
002020 0op ksf,
102020 0op ksn,
002040 0op rsf,
102040 0op rsn,
002100 0op tsf,
102100 0op tsn,
002200 0op ssf,
102200 0op ssn,
002400 0op hsf,
102400 0op hsn,

001000 1op iot,
: iot,   ['] #iot -addr iot, ;
: dlz,   001 iot, ;
: dla,   003 iot, ;
: ctb,   011 iot, ;
: dof,   012 iot, ;
: krb,   021 iot, ;
: kcf,   022 iot, ;
: krc,   023 iot, ;
: rrb,   031 iot, ;
: rcf,   032 iot, ;
: rrc,   033 iot, ;
: tpr,   041 iot, ;
: tcf,   042 iot, ;
: tpc,   043 iot, ;
: hrb,   051 iot, ;
: hof,   052 iot, ;
: hon,   061 iot, ;
: stb,   062 iot, ;
: scf,   071 iot, ;
: ios,   072 iot, ;
: rdi,   101 iot, ;
: arm,   141 iot, ;
: iof,   161 iot, ;
: ion,   162 iot, ;
: pun,   271 iot, ;
: psf,   274 iot, ;
: dcf,   304 iot, ;
: bel,   711 iot, ;

\ Addressing mode syntax.
: )   ['] indirect -addr ;
: #i   >lit ) ;
: #   >lit ;
: +#   0 +lit ) ;

\ Resolve jumps.
: >mark   here cell - ;
: >resolve   here cell/ swap jmp! ;

\ Unconditional jumps.
: label   here >r get-current ['] assembler set-current r> constant set-current ;
: begin,   here cell/ ;
: again,   jmp, ;
: ahead,   0 jmp, >mark ;
: then,   >resolve ;

\ Conditional jumps.
: zero   asz, jmp, ;
: less   asm, jmp, ;
: ge   asp, jmp, ;
: nonzero   asn, jmp, ;
: -link?   lsz, jmp, ;
: link?   lsn, jmp, ;
: 0=,   ['] zero ;
: 0<,   ['] less ;
: 0>=,   ['] ge ;
: 0<>,   ['] nonzero ;
: l0=,   ['] -link? ;
: l0<>,   ['] link? ;
: if,   0 swap execute >mark ;
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

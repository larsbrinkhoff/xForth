\ Copyright 2017 Lars Brinkhoff

\ Assembler for midrange PIC.

\ Adds to FORTH vocabulary: ASSEMBLER CODE ;CODE.
\ Creates ASSEMBLER vocabulary with: END-CODE and PIC opcodes.

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

\ Set opcode.
: opcode!   3@ drop >r opcode ! ;
: field!   opcode swap !bits ;
: !bit   7 lshift opcode +! ;
: !literal   00FF field! ;
: !f   007F field! ;
: !d   80 opcode +! ;
: addr   03FF field! ;


\ Access instruction fields.
: opcode@   opcode @ ;

\ Possibly use a cross-compiling vocabulary to access a target image.
previous definitions

\ Write instruction fields to memory.
: opcode,   opcode@ , ;
: jmp!   swap 03FF and swap +! ;

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
format: 1op   !f ;
format: byte-oriented   !f op ;
format: bit-oriented   !f !bit ;
format: literal-oriented   !literal ;
format: jump   2/ addr ;
format: movlb   opcode +! ;

\ Define registers

\ Instruction mnemonics.
previous also assembler definitions

0000 0op nop,
\ 0001*reset
0008 0op return,
0009 0op retfie,
\ 000A*callw
\ 000A*brw
\ 0010*moviw
\ 0018*movwi
0020 movlb movlb,
\ 0062 option
0063 0op sleep,
0064 0op clrwdt,

0080 1op movwf,
0180 1op clrf,
0100 0op clrw,
0200 byte-oriented subwf,
0300 byte-oriented decf,
0400 byte-oriented iorwf,
0500 byte-oriented andwf,
0600 byte-oriented xorwf,
0700 byte-oriented addwf,
0800 byte-oriented movf,
0900 byte-oriented comf,
0A00 byte-oriented incf,
0B00 byte-oriented decfsz,
0C00 byte-oriented rrf,
0D00 byte-oriented rlf,
0E00 byte-oriented swapf,
0F00 byte-oriented incfsz,

1000 bit-oriented bcf,
1400 bit-oriented bsf,
1800 bit-oriented btfsc,
1C00 bit-oriented btfss,

2000 jump call,
2800 jump goto,

3000 literal-oriented movlw,
\ 3100*addfsr
\ 3180*movlp
\ 3200*bra
3400 literal-oriented retlw,
\ 3500*lslf
\ 3600*lsrf
\ 3700*asrf
3800 literal-oriented iorlw,
3900 literal-oriented andlw,
3A00 literal-oriented xorlw,
\ 3B00*subwfb
3C00 literal-oriented sublw,
\ 3D00*addwfc
3E00 literal-oriented addlw,
\ 3F00*moviw
\ 3F80*movwi


\ Register names.
: w   ['] noop -addr ;
: f   ['] !d -addr ;
: indf   0 ;
: pcl   1 ;
: status   3 ;
: fsr   4 ;
: pclath   0A ;
: intcn   0B ;
: option_reg   81 ;

\ Resolve jumps.
: >mark   here cell - ;
: >resolve   here 2/ swap jmp! ;

\ Unconditional jumps.
: label   here >r get-current ['] assembler set-current r> constant set-current ;
: begin,   here ;
: again,   goto, ;
: ahead,   0 goto, >mark ;
: then,   >resolve ;

\ Conditional jumps.
: zero?   2 status btfss,  goto, ;
: not-zero?   2 status btfsc,  goto, ;
: 0=,   ['] zero? ;
: 0<>,   ['] not-zero? ;
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

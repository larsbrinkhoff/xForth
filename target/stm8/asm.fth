\ Copyright 2017 Lars Brinkhoff

\ Assembler for STM8.

\ Adds to FORTH vocabulary: ASSEMBLER CODE ;CODE.
\ Creates ASSEMBLER vocabulary with: END-CODE and AVR opcodes.

\ This will become a cross assembler if loaded with a cross-compiling
\ vocabulary at the top of the search order.

\ Conventional prefix syntax: "<source> <destination> <opcode>,".
\ Addressing modes:
\ - immediate: "n #"
\ - absolute: n
\ - register: a, sp, x, y, xl, xh, yl, yh
\ - indexed: (<reg>)
\ - indexed and offset: n ,<reg>)
\ - indirect: n )
\ - indirect and indexed: n ),<reg>)

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
variable prefix
defer !modeprefix
variable data   defer ?data,

\ Set opcode.
: opcode!   3@ drop >r opcode ! ;
: !mode   mode +! ;
: !prefix   prefix ! ;
: !foo-modeprefix   2drop !mode !prefix ;
: !bar-modeprefix   !mode !prefix 2drop ;
: !no-modeprefix   2drop 2drop ;

\ Access instruction fields.
: opcode@   opcode @ mode @ + ;
: mode@   mode @ ;
: prefix@   prefix @ ;
: prefix!   prefix ! ;
: data@   data @ ;

\ Possibly use a cross-compiling vocabulary to access a target image.
previous

\ Write instruction fields to memory.
: w,   dup 8 rshift c, c, ;
: w!   over 8 rshift over c! 1+ c! ;
: ?prefix,   prefix@ ?dup if c, then ;
: opcode,   ?prefix, opcode@ c, ;
: data8,   data@ c, ;
: data16,   data@ w, ;
: pc-   here - 2 - ;

also forth

: ?cpw   opcode@ C3 = if -20 opcode +! 0 r> drop then ;
: ?call   opcode@ BD = if 10 opcode +! 0 r> drop then ;
: ?exg   opcode@ 31 = if 0 r> drop then ;
: ?pop   opcode@ 32 = if 0 r> drop then ;
: ?push   opcode@ 3B = if 0 r> drop then ;
: ?ldw   opcode@ AE = if 0 r> drop then ;
: short?   ?ldw ?push ?pop ?exg ?call ?cpw  dup 100 u< ;

: range-error   ." Jump range error: " source type abort ;
: ?range   dup -80 80 within 0= if range-error then ;

\ Set operand data.
: !data8   data !  ['] data8, is ?data, ;
: !data16   data !  ['] data16, is ?data, ;
: !data   short? if !data8 else !data16 then ;

: ?pop   opcode@ 42 = if 44 opcode ! then ;
: ?push   opcode@ 8F = if 06 opcode ! then
          opcode@ 4B = if 48 opcode ! then ;

\ Implements addressing modes.
: imm-op   !modeprefix !data ;
: accumulator   !modeprefix ?pop ?push ;
: index   !modeprefix ;
: absolute   !modeprefix !data ;
: indexed   !modeprefix !data ;
: indexed-no-offset   !modeprefix ;
: indexed-sp   !modeprefix !data8 ;
: indirect   !modeprefix !data ;
: indirect-indexed   !modeprefix !data ;

\ Reset assembler state.
: 0mode   0 mode ! ;
: 0prefix   0 prefix ! ;
: 0data   ['] noop is ?data, ;
: 0modeprefix   ['] !no-modeprefix is !modeprefix ;
: 0op   0 opcode ! ;
: 0asm   0mode 0prefix 0data 0modeprefix 0op ;

\ Process one operand.  All operands except a direct address
\ have the stack picture ( n*x xt -addr ).
: addr?   dup -addr <> ;
: absolute   short? if 00 30 00 B0 else 72 50 00 C0 then absolute ;
: op   addr? if absolute else drop execute then ;

\ 
: !foo   ['] !foo-modeprefix is !modeprefix ;
: !bar   ['] !bar-modeprefix is !modeprefix ;

\ Define instruction formats.
: instruction,   opcode! opcode, ?data, 0asm ;
: mnemonic ( u a "name" -- ) create ['] noop 3,  does> instruction, ;
: format:   create ] !csp  does> mnemonic ;

\ Instruction formats.
format: 0op ;
format: 1op   op ;
format: 1op90  90 c, op ;
format: 2op  op op ;
format: 1foo   !foo op ;
format: 1bar   !bar op ;
format: ldx   !bar op  prefix@ 90 = if 0 prefix! then ;
format: ldy   !bar op
 prefix@ dup 72 = swap 92 = or if 91 prefix! exit then
 prefix@ 91 = if exit then
 mode@ 10 = if -8 opcode +! else 90 prefix ! then ;
format: sty   !bar op
 prefix@ 92 = mode@ C0 = and if 91 prefix! exit then
 mode@ 10 = if -8 opcode +! then
 mode@ dup B0 = swap C0 = or if 90 prefix ! then ;
format: jump   pc- ?range !data8 ;

\ Instruction mnemonics.
previous also assembler definitions

\ Addressing mode: no operand.
80 0op iret,
81 0op ret,
83 0op trap,
65 0op divw,
51 0op exgw,
87 0op retf,
8B 0op break,
8C 0op ccf,
8E 0op halt,
8F 0op wfi,
98 0op rcf,
99 0op scf,
9A 0op rim,
9B 0op sim,
9C 0op rvf,
9D 0op nop,

\ Addressing mode: register.
01 1op rrwa,
02 1op rlwa,
42 1op mul,
50 1op negw,
53 1op cplw,
54 1op srlw,
56 1op rrcw,
57 1op sraw,
58 1op sllw,
59 1op rlcw,
5A 1op decw,
5C 1op incw,
5D 1op tnzw,
5E 1op swapw,
5F 1op clrw,
62 1op div,
85 1op popw,
89 1op pushw,
95 1op ldxh,
97 1op ldxl,
95 1op90 ldyh,
97 1op90 ldyl,

\ Addressing mode: accumulator/memory.
00 1foo neg,
01 1foo exg,
02 1foo pop,
03 1foo cpl,
04 1foo srl,
06 1foo rrc,
07 1foo sra,
08 1foo sll,
09 1foo rlc,
0A 1foo dec,
0B 1foo push,
0C 1foo inc,
0D 1foo tnz,
0E 1foo swap,
0F 1foo clr,

\ Addressing mode: immediate/memory.
00 1bar sub,
01 1bar cp,
02 1bar sbc,
03 1bar cpw,
04 1bar and,
05 1bar bcp,
06 1bar lda,
07 1bar sta,
08 1bar xor,
09 1bar adc,
0A 1bar or,
0B 1bar add,
0C 1bar jp,
0D 1bar call,
0E ldx ldx,
0E ldy ldy,
0F 1bar stx,
0F sty sty,
0F 1bar ldsp,

\ Addressing mode: immediate/memory, memory.
05 2op mov,

: addsp,   5B c, c, ;
: subsp,   52 c, c, ;
\ ... addw,
\ ... subw,
20 jump jra,
21 jump jrf,
22 jump jrugt,
23 jump jrule,
24 jump jrnc, \ jruge,
25 jump jrc, \ jrult,
26 jump jrne, 
27 jump jreq,
28 jump jrnv,
\ 9028 jrnh,
\ 9029 jrh,
2A jump jrpl,
2B jump jrmi,
2C jump jrsgt,
\ 902C jrnm,
2D jump jrsle,
\ 902D jrm,
2E jump jrsge,
\ 902E jril,
2F jump jrslt,
\ 902F jrih,
\ 53 cplw,
\ 7200 btjf,
\ 7200 btjt,
\ 7210 bres,
\ 7210 bset,
: int,   82 c,  dup 010 rshift c,  w, ;
: wfe,   72 c, 8F c, ;
\ 9010 bccm,
\ 9010 bcpl,
AD jump callr,

\                neg  sub cpwx cpwy ldwx ldwy ldwmx ldwmy pop popw push pushw addwx addwy subwx subwy exg
\ mode: #              A0   A0 90A0   A0 90A0                        4B         1C  72A9    1D  72A2
\ mode: a         40                                       84        88       
\ mode: x                                9093                   85         89 
\ mode: y                             93                      9085       9089 
\ mode: xl                                                                                             41
\ mode: yl                                                                                             61
\ mode: sp                            96 9096   94                            "5B"        "52"
\ mode: cc                                                 86        8A       
\ mode: memS      30   B0   B0 90B0   B0 90B0   B0  90B0                      
\ mode: memL    7250   C0   C0 90C0   C0 90C0   C0  90C0   32        3B       72BB  72B9  72B0  72B2   31
\ mode: (x)       70   F0        F0   F0                                    
\ mode: (y)     9070 90F0 90F0           90F0 90F0    F0                    
\ mode: ,x)S      60   E0        E0   E0      90E0    E0                    
\ mode: ,x)L    7240   D0        D0   D0      90D0    D0                    
\ mode: ,y)S    9060 90E0 90E0           90E0                               
\ mode: ,y)L    9040 90D0 90D0           90D0                               
\ mode: ,sp)      00   10   10        10   16   10    17                      72FB  72F9  72F0  72F2  
\ mode: )S      9230 92C0 92C0 91C0 92C0 91C0 92C0  91C0                    
\ mode: )L      7230 72C0 72C0      72C0 91D0 72C0                          
\ mode: ),x)S   9260 92D0      92D0 92D0      92D0  92D0                    
\ mode: ),x)L   7260 72D0      72D0 72D0      72D0  92D0                    
\ mode: ),y)    9160 91D0 91D0                                              

\ Addressing mode syntax.
\ Stack: ( foo-prefix foo-mode bar-prefix bar-mode )
: #      00 40 00 A0 ['] imm-op -addr ;
: a      00 40 00 00 ['] accumulator -addr ;
: x      00 00 00 85 ['] index -addr ;
: y      90 00 90 85 ['] index -addr  90 !prefix ;
: sp     00 00 00 88 ['] accumulator -addr ;
: cc     00 84 00 00 ['] accumulator -addr ;
: xl     00 40 00 95 ['] accumulator -addr ;
: xh     00 00 00 99 ['] accumulator -addr ;
: yl     00 60 90 95 ['] accumulator -addr ;
: yh     00 00 90 99 ['] accumulator -addr ;
: (x)    00 70 00 F0 ['] indexed-no-offset -addr ;
: (y)    90 70 90 F0 ['] indexed-no-offset -addr ;
: ,x)    short? if 00 60 00 E0 else 72 40 72 D0 then ['] indexed -addr ;
: ,y)    short? if 90 60 90 E0 else 90 40 90 D0 then ['] indexed -addr ;
: ,sp)   00 00 00 10 ['] indexed-sp -addr ;
: )      short? if 92 30 92 C0 else 72 30 72 C0 then ['] indirect -addr ;
: ),x)   short? if 92 60 92 D0 else 72 60 72 D0 then ['] indirect-indexed -addr ;
: ),y)   91 60 91 D0 ['] indirect-indexed -addr ;

\ Aliases

\ Resolve jumps.
: >mark   here 1- here ;
: long?   dup 7F > over -80 < or ;
: long!   1- 0CC swap c!+ here swap w! ;
: >resolve   here swap - long? if drop long! else swap c! then ;

\ Unconditional jumps.
: label   here >r get-current ['] assembler set-current r> constant set-current ;
: begin,   here ;
: again,   jra, ;
: ahead,   here jra, >mark ;
: then,   >resolve ;

\ Conditional jumps.
: 0=,   ['] jrne, ;
: 0<,   ['] jrpl, ;
: 0<>,   ['] jreq, ;
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

\ Assembler for IMLAC PDS-1 display instructions.

also assembler definitions
octal

variable display-dp

: >dis   r> 'dp @ >r >r display-dp 'dp ! ;
: dis,   >dis ,  r> r> 'dp ! >r ;
: dis-here   display-dp @ ;

000000 0op dhlt,
004000 0op dnop,
004001 0op dadr,
004004 0op dsts0,
004005 0op dsts1,
004006 0op dsts2,
004007 0op dsts3,
004010 0op dstb0,
004011 0op dstb0,
004012 0op dstb0,
004013 0op dstb0,
004020 0op ddsp,
004040 0op drjm,
004100 0op ddym,
004200 0op ddxm,
004400 0op diym,
005000 0op dixm,
006000 0op dhvc,

010000 1op dlxa,
020000 1op dlya,
\ 030000 1op deim,
\ 000000 2op dinc,
\ 040000 dlvh,
050000 1op djms,
060000 1op djmp,

variable inc-byte 177400

: inc:   create dup 8 lshift or ,
   does> @ inc-byte @ field!  inc-byte @ 177777 xor inc-byte ! ;
: inc,   opcode, ;

: bright 100 ;
: dim ;

270 7 inc: -3-3  270 6 inc: -3-2  270 5 inc: -3-1  270 4 inc: -3-0
270 3 inc: -3+3  270 2 inc: -3+2  270 1 inc: -3+1  270 0 inc: -3+0

260 7 inc: -2-3  260 6 inc: -2-2  260 5 inc: -2-1  260 4 inc: -2-0
260 3 inc: -2+3  260 2 inc: -2+2  260 1 inc: -2+1  260 0 inc: -2+0

250 7 inc: -1-3  250 6 inc: -1-2  250 5 inc: -1-1  250 4 inc: -1-0
250 3 inc: -1+3  250 2 inc: -1+2  250 1 inc: -1+1  250 0 inc: -1+0

240 7 inc: -0-3  240 6 inc: -0-2  240 5 inc: -0-1  240 4 inc: -0-0
240 3 inc: -0+3  240 2 inc: -0+2  240 1 inc: -0+1  240 0 inc: -0+0

230 7 inc: +3-3  230 6 inc: +3-2  230 5 inc: +3-1  230 4 inc: +3-0
230 3 inc: +3+3  230 2 inc: +3+2  230 1 inc: +3+1  230 0 inc: +3+0

220 7 inc: +2-3  220 6 inc: +2-2  220 5 inc: +2-1  220 4 inc: +2-0
220 3 inc: +2+3  220 2 inc: +2+2  220 1 inc: +2+1  220 0 inc: +2+0

210 7 inc: +1-3  210 6 inc: +1-2  210 5 inc: +1-1  210 4 inc: +1-0
210 3 inc: +1+3  210 2 inc: +1+2  210 1 inc: +1+1  210 0 inc: +1+0

200 7 inc: +0-3  200 6 inc: +0-2  200 5 inc: +0-1  200 4 inc: +0-0
200 3 inc: +0+3  200 2 inc: +0+2  200 1 inc: +0+1  200 0 inc: +0+0

100 inc: diexit
140 inc: diexit-and-return
040 inc: direturn
020 inc: dixmsb
010 inc: di0xlsb
002 inc: diymsb
001 inc: di0ylsb

\ else escape
\ T = 100 = exit
\ X = 140 = exit and return
\      40 = return
\      20 = inc X MSB
\      10 = zero X LSB
\       4 = PPM mode
\       2 = inc Y MSB
\       1 = zero Y LSB
\ R = 151

previous definitions

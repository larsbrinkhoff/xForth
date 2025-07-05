\ IMLAC PDS-1 backend.
\
\ Subroutine threaded.  To save space, most operations are NOT inlined.
\
\ Register usage:
\ AC - TOS

only forth
octal

6 constant temp1
7 constant temp2
10 constant sp
11 constant rp

1 constant t-cell

also meta definitions also assembler

: header,   header,  0 , ;

: >page   13 rshift ;
: near?   dup >page  here cell/ >page = ;
: comp,   cell/ near? if jms, else #i jms, then ;

definitions
: exit,   latest cell/ ) jmp, ;
: 0branch,   s" 0branch" "' comp, ;
: push,   s" push" "' comp, ;
previous definitions also assembler

: t-num
   push,
   dup 0 4000 within if law, exit then
   dup -3777 0 within if negate lwc, exit then
   # lac, ;

: '   ' cell/ ;

: prologue, ;
: end-target   page ;

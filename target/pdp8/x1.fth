\ PDP-8 backend.
\
\ Subroutine threaded.  To save space, most operations are NOT inlined.
\
\ Register usage:
\ AC - TOS

only forth
octal

5 constant temp1
6 constant temp2
7 constant temp3
10 constant sp
11 constant rp

1 constant t-cell

also meta definitions also assembler

: header,   header,  0 , ;

: >page   7 rshift ;
: near?   dup >page dup 0=  swap here cell/ >page = or ;
: comp,   cell/ near? if jms, else #i jms, then ;

: exit,   latest cell/ ) jmp, ;

: 0branch,   s" 0branch" "' comp, ;
: push,   s" push" "' comp, ;

: t-num   push,  # tad, ;

: '   ' cell/ ;

: prologue, ;
: end-target   page ;

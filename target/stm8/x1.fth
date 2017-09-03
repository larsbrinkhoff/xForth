\ STM8 backend.
\
\ Subroutine threaded.  To save space, most operations are NOT inlined.
\
\ Register usage:
\ A  - temporary.
\ X  - data stack pointer.
\ Y  - temporary.
\ SP - return stack pointer.
\
\ TOS is in low memory, where it can be accessed using the short
\ memory addressing mode.

only forth

0 constant tos
2 ram-dp !

also meta definitions also assembler

: pc-   here - 2 - ;
: short?   dup pc- -128 128 within ;
: comp,   short? if callr, else call, then ;

: branch?,   s" branch?" "' comp, 0<>, ;
: dup,   s" dup" "' comp, ;

: t-num   dup,  # ldy,  tos sty, ;

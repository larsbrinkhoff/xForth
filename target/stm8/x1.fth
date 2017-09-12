\ STM8 backend.
\
\ Subroutine threaded.  To save space, most operations are NOT inlined.
\
\ Register usage:
\ A  - temporary.
\ X  - data stack pointer.
\ Y  - temporary.
\ SP - return stack pointer.

only forth

0 ram-dp !

also meta definitions also assembler

: pc-   here - 2 - ;
: short?   dup pc- -128 128 within ;
: comp,   short? if callr, else call, then ;

: branch?,   s" branch?" "' comp, 0<>, ;
: dup,   s" dup" "' comp, ;

: !#   # lda,  (x) sta, ;
: !0   (x) clr, ;
: push   x decw,  255 and ?dup if !# else !0 then ;
: t-num   dup push 8 rshift push ;

: end-target ;

\ 8051 backend.
\
\ Subroutine threaded.  To save space, most operations are NOT inlined.
\
\ Register usage:
\ A - temporary.
\ B - temporary.
\ DPTR - TOS
\ R0 - data stack pointer.
\ R1-R4 - temporary.
\ SP - return stack pointer.

only forth

also meta definitions also assembler

: pc-   here - 2 - ;
: short?   dup pc- -128 128 within ;
: comp,   short? if acall, else lcall, then ;

definitions
: branch?,   s" branch?" "' comp, 0<>, ;
: dup,   s" dup" "' comp, ;
previous definitions also assembler

: t-num   dup,  # dptr mov, ;

: prologue, ;
: end-target ;

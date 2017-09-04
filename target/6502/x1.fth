\ 6502 backend.
\
\ Subroutine threaded.  To save space, most operations are NOT inlined.
\
\ Register usage:
\ A - temporary.
\ X - data stack pointer.
\ Y - temporary.
\ SP - return stack pointer.
\
\ Zero page usage:
\ 40-41 TOS - top of stack.
\ 42-43 W - temporary.
\ E0-FF - data stack.

only forth

224 constant stack-lo
240 constant stack-hi
64 constant tos
66 constant w

0 ram-dp !

also meta definitions also assembler

: comp,   jsr, ;

: branch?,   s" branch?" "' comp, 0<>, ;
: dup,   s" dup" "' comp, ;

: t-num   s" (lit)" "' comp,   w, ;

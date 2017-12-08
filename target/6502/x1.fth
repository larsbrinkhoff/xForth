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

also meta definitions also assembler

: comp,   jsr, ;

: branch?,   s" branch?" "' comp, 0<>, ;
: dup,   s" dup" "' comp, ;

: store   255 and # lda,  ,x sta, ;
: t-num   dex,  stack-lo over store  stack-hi swap 8 rshift store ;

: prologue, ;
: end-target ;

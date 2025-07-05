\ PIC backend.
\
\ Subroutine threaded.  To save space, most operations are NOT inlined.
\
\ Register usage:


only forth

32 constant s
34 constant t
36 constant x
38 constant rp

also meta definitions also assembler

: comp,   call, ;

definitions
: branch?,   s" branch?" "' call, 0<>, ;
: dup,   s" dup" "' call, ;
previous definitions also assembler

: t-num   dup,  dup 255 and movlw, t movwf,  8 rshift movlw, t 1+ movwf, ;

: prologue, ;
: end-target ;

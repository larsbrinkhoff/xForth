\ MSP430 backend.
\
\ Subroutine threaded.  Operations no longer than a CALL instruction
\ are inlined.
\
\ Register usage:
\ r0    Program counter.
\ r1    Return stack pointer.
\ r2    Status register.
\ r4    Data stack pointer.
\ r5    Top of stack.
\ r6    Temporary.


only forth

hex 0200 ram-dp ! decimal

also meta definitions also assembler

: comp,   # call, ;

: branch?,   r5 tst,  r4 )+ r5 mov,  0<>, ;
: dup,   s" dup" "' # call, ;

: t-num   dup,  # r5 mov, ;

: end-target ;

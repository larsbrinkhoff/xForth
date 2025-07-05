\ ARM Thumb backend.
\
\ Subroutine threaded.  Operations no longer than a CALL instruction
\ are inlined.
\
\ Register usage:
\ R5 - temporary.
\ R6 - top of stack.
\ R7 - data stack pointer.
\ SP - return stack pointer.
\ LR - link register.

only forth

hex

also meta definitions also assembler

: prologue,   {lr} push, ;
: comp,   bl, ;

definitions
: branch?,   s" branch?" "' bl, 0<>, ;
: dup,   4 # r7 subi,  r7 ) r6 str, ;
previous definitions also assembler

: small?   dup 100 u< ;
: small   # r6 movi, ;
: large   dup 18 rshift # r6 movi,  18 # r6 r6 lsli,
          dup 10 rshift # r5 movi,  10 # r5 r5 lsli,  r6 r5 r6 add,
          dup 8 rshift # r5 movi,  8 # r5 r5 lsli,  r6 r5 r6 add,
          FF and # r6 addi, ;
: t-num   dup,  small? if small else large then ;

: end-target ;

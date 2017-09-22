\ AVR backend.
\
\ Subroutine threaded.  To save space, most operations are NOT inlined.
\ In small devices, the 16-bit RCALL instruction will be used.
\
\ Register usage:
\ X      - TOS
\ Y      - Data stack pointer
\ Z      - Temporary
\ r2-r3  - Temporary
\ SP     - Return stack pointer


only forth

96 ram-dp !

also meta definitions also assembler

: short?   dup here - 4096 < ;
: comp,   short? if rcall, else call, then ;

: branch?,   s" branch?" "' rcall, 0<>, ;
: dup,   s" dup" "' rcall, ;

: t-num   dup,  dup 255 and # r26 ldi,  8 rshift # r27 ldi, ;

: prologue, ;
: end-target ;

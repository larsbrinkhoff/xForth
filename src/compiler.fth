\ Copyright 2017 Lars Brinkhoff.

\ AVR cross compiler.
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


: h: : ;

1 constant t-little-endian
2 constant t-cell
include lib/meta.fth

only forth also meta definitions

include target/avr/asm.fth

also assembler
: header, ( a u -- ) here t-word ;

: short?   dup here - 4096 < ;
: comp,   short? if rcall, else call, then ;

: branch?,   s" branch?" "' rcall, 0<>, ;
: dup,   s" dup" "' rcall, ;

: t-num   dup,  dup 255 and # r26 ldi,  8 rshift # r27 ldi, ;
: dovar, ;

also forth
' comp, is t-compile,
' t-num is t-literal

0 org

host also meta definitions

h: :   parse-name header, ] ;
h: create   parse-name header, dovar, ;
h: variable   create cell allot ;

h: code   parse-name header,  also assembler ;
h: end-code   previous ;

only forth also meta also compiler definitions previous

also assembler
h: exit   ret, ;
h: nip   2 # r28 adiw, ;
h: cell+   2 # r26 adiw, ;
h: 1+   1 # r26 adiw, ;
h: 1-   1 # r26 sbiw, ;

h: if   branch?, if, ;
h: ahead   ahead, ;
h: then   then, ;
h: else   else, ;

h: begin   begin, ;
h: again   again, ;
h: until   branch?, until, ;
h: while   branch?, while, ;
h: repeat   repeat, ;
previous

h: ;   [compile] exit [compile] [ ;
h: [']   ' t-literal ;
h: [char]   char t-literal ;
h: literal   t-literal ;
\ h: does>

2 t-constant cell

target

include src/kernel.fth

only forth also meta also t-words resolve-all-forward-refs

only forth also meta save-target

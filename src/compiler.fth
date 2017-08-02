\ Copyright 2017 Lars Brinkhoff.

\ AVR cross compiler.
\
\ Subroutine threaded.  To save space, most operations are NOT inlined.
\ In small devices, the 16-bit RCALL instruction will be used.
\
\ Register usage:
\ r0, r1 - TOS
\ r2     - Temporary
\ Y      - Data stack pointer
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

: t-num ;
: dovar, ;

: branch?,   s" branch?" "' rcall, 0<>, ;

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

h: if   branch?, if, ;
h: ahead   ahead, ;
h: then   then, ;

h: begin   begin, ;
h: again   again, ;
h: until   branch?, until, ;
h: while   branch?, while, ;
h: repeat   repeat, ;
previous

h: ;   [compile] exit [compile] [ ;
\ h: [']
\ h: [char]
\ h: literal
\ h: compile
\ h: [compile]
\ h: does>

2 t-constant cell

target

include src/kernel.fth

only forth also meta also t-words resolve-all-forward-refs

only forth also meta save-target

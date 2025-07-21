\ Copyright 2025 Lars Brinkhoff.

\ Forth kernel for embedded devices, with interpreter and optional
\ compiler.  Requires the words listed in README.md, plus these:
\ EXECUTE SP0 RP0 EMIT KEY

decimal

host also meta definitions
h: a:   : also assembler ;
target

defer abort

include lib/core.fth
include lib/dict.fth
include lib/input.fth
: undefined   ."  Undefined: " type cr abort ;
: forget
   parse-name find-name ?dup 0= if undefined then
   dup >next 'latest ! dp ! ;
include lib/number.fth
: '   parse-name find-xt 0= if undefined then ;
octal
: .s   10 @ 7700 begin 1- 2dup < while dup @ . repeat 2drop ;
include lib/interpreter.fth
include lib/compiler.fth

: (abort)   sp0  data  quit [   ' (abort) is abort

: banner   cr ." IMLACForth" cr ;
: warm
   then
   [ latest cell/ ] literal 'latest !
   code-dp0 @ code-dp !
   data-dp0 @ data-dp !
   banner abort [

here cell/ 'code-dp0 !
ram-here cell/ 'data-dp0 !

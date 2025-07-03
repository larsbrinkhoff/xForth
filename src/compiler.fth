\ Copyright 2017 Lars Brinkhoff.

\ Forth cross compiler.


: h: : ;
: h-c@+ ( a -- a' x ) dup 1+ swap c@ ;

0 value latest

include target/params.fth
include lib/meta.fth

variable ram-dp
data-start ram-dp !
: ram-here   ram-dp @ ;
: ram-allot   ram-dp +! ;

: string,   dup t,  begin dup while 1-  swap h-c@+ t, swap repeat 2drop ;

only forth also meta definitions

include target/asm.fth

: header, ( a u -- ) here t-word  here to latest ;
: ram,   ram-here !  cell ram-allot ;

include target/x1.fth

also forth
' comp, is t-compile,
' t-num is t-literal

host also meta definitions

: o.   base @ swap octal . base ! ;
: peek  2dup type space here cell/ o. cr ;
h: :   source type cr parse-name peek header, prologue, ] ;
h: constant   t-constant ;
h: create   ram-here cell/ t-constant ;
h: variable   ram-here cell/ t-constant  cell ram-allot ;

h: code   parse-name header,  also assembler ;
h: end-code   previous ;

only forth also meta also compiler definitions previous
include target/x2.fth

h: ;   [compile] exit [compile] [ ;
h: [']   ' t-literal ;
h: [char]   char t-literal ;
h: literal   t-literal ;
h: [compile]   ' cell * comp, ;
h: compile   ' t-literal  s" compile," "' comp, ;
h: ."   s" (dot-quote)" "' comp,  [char] " parse string, ;

t-cell t-constant cell

target

program-start org
include target/nucleus.fth
include app.fth

octal
.( Code: ) here cell/ . cr
.( Latest: ) latest cell/ . cr
.( Literals: ) lit@ . cr
.( Data: ) ram-here cell/ . cr

end-target

only forth also meta also t-words resolve-all-forward-refs

only forth also meta save-target

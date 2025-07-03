\ Copyright 2025 Lars Brinkhoff.

\ Forth kernel for embedded devies, with interpreter and optional
\ compiler.  Requires the words listed in README.md, plus these:
\ EXECUTE SP0 RP0 EMIT KEY

decimal

: tuck   swap over ;
: 2dup   over over ;
: 2drop   drop drop ;
: rot   >r swap r> swap ;
: abs   dup 0< if negate then ;
: 1-   1 - ;
: <   - 0< ;
: >   swap < ;
: >=   < invert ;
: <=   > invert ;
: u<   2dup xor 0< if nip 0< else - 0< then ;
: within   over - >r - r> u< ;
: not   0= ;

host also meta definitions
h: a:   : also assembler ;
target

variable a   : a! a ! ;   : a@ a @ ;   : @a+ a @ 1 a +! ;
variable b   : b! b ! ;   : b@ b @ ;   : @b+ b @ 1 b +! ;

: cr   10 emit  13 emit ;

: string= ( a1 u1 a2 u2 -- ? )
   swap a!  rot b!
   tuck <> if drop 0 exit then
   begin dup while 1- @a+ @b+ <> if drop 0 exit then repeat drop -1 ;

: type   swap a! begin dup while 1- @a+ emit repeat drop ;

include lib/dict.fth
include lib/input.fth
include lib/number.fth
include lib/interpreter.fth
include lib/compiler.fth

: (.")   r> dup @string 2dup type + >r ;
host also meta definitions
\ h: ."   ( compile ) (.") [char] " parse string, ; immediate
target

: abort   sp0  quit ;
: '   parse-name find-name 0= abort ;

: banner   ." IMLAC larbsForth" cr ;
: warm   then  [ latest ] literal name-dp !  banner  abort ;

include target/x3.fth

: tuck   swap over ;
: rot   >r swap r> swap ;
: ?dup   dup if dup then ;
: 2dup   over over ;
: 2drop   drop drop ;
: 2swap   >r rot rot r> rot rot ;
: abs   dup 0< if negate then ;
: negate   negate ;
: <   - 0< ;
: >   swap < ;
: >=   < invert ;
: <=   > invert ;
: 0>=  0< invert ;
: 0>   0 > ;
: u<   2dup xor 0< if nip 0< else - 0< then ;
: within   over - >r - r> u< ;
: not   0= ;
: @+ ( a -- a' x ) dup cell+ swap @ ;
: !+ ( x a -- a' ) tuck ! cell+ ;
: noop ;
octal
: depth   6776 10 @ - ;
: (is) ( xt1 xt2 -- ) 3 + ! ;
decimal

variable a   : a! a ! ;   : a@ a @ ;   : @a+ a@ cell a +! ;   : c@a+ a@ c@ 1 a +! ;
variable b   : b! b ! ;   : b@ b @ ;   : @b+ b@ cell b +! ;   : c@b+ b@ c@ 1 b +! ;

: string= ( a1 u1 a2 u2 -- ? )
   swap a!  rot b!
   tuck <> if drop 0 exit then
   begin ?dup while 1- c@a+ c@b+ <> if drop 0 exit then repeat -1 ;

: type   swap a!  begin ?dup while 1- c@a+ emit repeat ;
: (dot-quote)   r> @+ 2dup type + >r ;
: space   32 emit ;
: cr   10 emit  13 emit ;

: *
   1 swap >r >r 0 swap begin r@ while
      r> r> swap 2dup 2* swap >r >r and if swap over + swap then 2*
   repeat r> r> 2drop drop ;

: u/mod ( n d -- r q )
    dup 0= if ." Division by zero." cr abort then
    0 >r swap >r >r	\ R: q n
    0 1 begin ?dup while dup 2* repeat
    r> 0 begin		\ S: [...1<<i...] d r
      2*		\ r <<= 1
      r@ 0< if 1+ then	\ if n&msb then r++
      r> 2* >r		\ n <<= 1
      2dup > if rot drop else \ if r>=d
        over -		      \ r -= d
        rot r> r> rot + >r >r \ q += 1<<i
      then
      >r >r ?dup r> r> rot 0= until
    nip r> drop r> ;

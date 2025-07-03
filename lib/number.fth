create base  10 ,

: octal   8 base ! ;
: decimal   10 base ! ;

: 1/string   1- swap 1+ swap ;
: minus?   dup 0= if 0 else over c@ [char] - = then ;
: negate?   minus? if 1/string ['] negate else ['] noop then ;
: digit?   [char] 0 [char] 9 1+ within ;
: upper?   [char] A [char] Z 1+ within ;
: lower?   [char] a [char] a 1+ within ;
: digit
    dup digit? if [char] 0 - exit then
    dup upper? if [ char A 10 - ] literal - exit then
    dup lower? if [ char a 10 - ] literal - exit then
    r> r> r> undefined ;
: number
   2dup >r >r  negate? >r  swap a!  0
   begin swap ?dup while 1- swap base @ * c@a+ digit + repeat
   r> execute  r> r> 2drop ;

: .digit   dup 9 > if [ char A 10 - ] literal else [char] 0 then + ;
: (.)   base @ u/mod  ?dup if 0 >r (.) r> drop then  .digit emit ;
: u.   (.) space ;
: .   dup 0< if [char] - emit negate then u. ;

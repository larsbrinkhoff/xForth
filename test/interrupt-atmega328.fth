: DDRCOUT 255 39 c! ;

: PORTCON 255 40 c! ;

: PORTCOFF 0 40 c! ;

: DDRBOUT 255 36 c! ;

: PORTBON 255 37 c! ;

: PORTBOFF 0 37 c! ;

: 1MS 300 begin 1- dup 0= until drop ;

: MS begin 1MS 1- dup 0= until drop ;

: SETUPISR  12 105 c! 2 61 c! 128 95 c! ;

: myisr swr 37 c@ 255 xor 37 c! 500 MS rwr int;

variable abcd

: abc then  5 abcd ! 15 DDRCOUT DDRBOUT SETUPISR 3000 MS begin 1000 MS PORTCON 1000 MS PORTCOFF again ;

' myisr 2 isr!


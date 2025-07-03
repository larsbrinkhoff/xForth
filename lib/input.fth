decimal
80 constant #tib
create 'tib  80 cell * ram-allot
variable >in
variable #source

: source   'tib  #source @ ;
: source?   >in @ source nip < ;
: <source   source drop >in @ + c@  1 >in +! ;
: >source   source + c!  1 #source +! ;

: blank?   33 < ;
: -blank?   blank? invert ;
: char=   over = ;
: encountered ( xt -- a u )
   >in @ >r  >r
   begin source? while <source r@ execute until -1 >in +! then
   r> drop  source drop r@ +  >in @ r> - ;
: parse   ['] char= encountered rot drop  source? if 1 >in +! then ;
: parse-name
   ['] -blank? encountered 2drop
   ['] blank? encountered  source? if 1 >in +! then ;

: echo   dup emit ;
: more?   dup 10 <>  over 13 <> and ;
: refill
   0 >in !  0 #source !
   begin key more? while echo >source  source nip #tib = until exit then
   space drop ;

: \   source nip >in ! ; immediate
: (   [char] ) parse 2drop ; immediate

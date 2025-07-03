80 constant #tib
create 'tib  80 allot
variable >in
variable #source

: source   'tib  #source @ ;
: source?   >in @ source nip < ;
: <source   source drop >in @ + c@  1 >in +! ;
: >source   source + c!  1 #source 1+ ;

: blank?   33 < ;
: -blank?   blank? not ;
: encoutered ( xt -- a u )
   >r begin source? while <source r@ execute until -1 >in +! then r> drop ;
: parse   ['] <> encoutered ;
: parse-name   ['] blank? encoutered 2drop  ['] -blank? encoutered ;

: more?   dup 10 <>  over 13 <> and ;
: refill
   0 >in !  0 #source !
   begin key more? while >source  source nip #tib = until then ;

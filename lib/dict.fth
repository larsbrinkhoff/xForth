variable dp
: here   dp @ ;
: allot   dp +! ;
: ,   here !  1 allot ;

variable name-dp
: n-here   name-dp @ ;
: n,   n-here ,  1 name-dp +! ;

variable 'latest
: latest   'latest @ ;

: string,   swap a!  dup ,  begin dup while 1- @a+ , repeat drop ;
: @string   dup @ swap 1+ ;

: link,   latest n,  'latest ! ;
: name,   here >r  n-here dp !  string,  here name-dp !  r> dp ! ;
: header,   n-here link,  here n,  name,  0 , ;

: >next   @ ;
: >xt   1+ @ ;
: >name   2 + dup @ swap 1+ ;
: name=   >name string= ;

: found?   >r a@ b@ r@ name= if r> >xt -1 else r> 0 then ;
: find-name ( a u -- 0 | xt 1 | xt -1 )
   b! a!
   latest begin dup while
     dup found? if rot drop exit else drop then
     >next repeat
   drop ;

: latestxt   latest >xt ;

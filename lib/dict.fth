decimal

variable 'dp
: dp   'dp @ ;
: here   dp @ ;
: allot   dp +! ;
: ,   here !  cell allot ;

variable code-dp
variable data-dp
ram-here to 'code-dp0   variable code-dp0
ram-here to 'data-dp0   variable data-dp0

: code   code-dp 'dp ! ;
: data   data-dp 'dp ! ;

variable 'latest
: latest   'latest @ ;

: string,   swap a!  dup ,  begin dup while 1- c@a+ , repeat drop ;

: link,   data here  latest ,  'latest ! ;
: xt,   code here data , ;
: name,   string, ;
: code,   code , data ;
: header,   link, xt, name, code, 0 ;

: >link   ;
: >next   >link @ ;
: 'xt   1+ ;
: >xt   'xt @ 32767 and ;
: >body  >xt ;
: >name   2 + @+ ;
: name=   a@ >r b@ >r  >name string=  r> b! r> a! ;
: immediate?   'xt @ 32768 and if 1 else -1 then ;

: found? ( nt -- ? ) a@ b@ rot name= ;
: find-name ( a u -- a u 0 | nt )
   b! a!
   latest begin dup while dup found? if exit then >next repeat
   a@ b@ rot ;
: find-xt   find-name dup if dup >xt swap immediate? then ;

: words   latest begin ?dup while dup >name space type >next repeat ;

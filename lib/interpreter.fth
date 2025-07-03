variable state
create interpreters  ' execute , ' number , ' execute ,
: interpret-xt   1+ cells  interpreters + @ ;
: parsed   find-name interpret-xt ;
: [   0 state !  ['] execute interpreters ! ; immediate

: prompt   ."  ok " cr ;
: ?prompt   state @ 0= if prompt then ;
: interpret   begin parse-name dup while parsed repeat 2drop ;
: quit   rp0  [compile] [  begin ?prompt refill interpret again ;

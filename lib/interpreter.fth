: ok   ."  Ok " cr ;
create interpreter-state   0 ,  ' execute , ' number , ' execute ,  ' ok ,
variable 'state
: state   'state @ ;
: interpret-xt   2 + cells  state + @ execute ;
: prompt   state 4 cells + @ execute ;

: parsed   find-xt interpret-xt ;
: interpret   begin parse-name dup while parsed repeat 2drop ;
: [   interpreter-state 'state ! ; immediate
: quit   rp0  [compile] [  begin refill interpret prompt again [

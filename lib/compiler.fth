a: exit   latestxt [compile] ) [compile] jmp, ;
: near? ;
a: compile,   near? if [compile] jms, else [compile] #i [compile] jms, then ;

a: literal
   push,
   dup 0 4000 within if [compile] law, exit then
   dup -3777 0 within if negate [compile] lwc, exit then
   [compile] # [compile] lac, ;

: ]   1 state !  ['] compile, interpreters ! ;
: :   parse-name header,  ] ;
: ;   [compile] exit  [compile] [ ;

octal

: latestxt   latest >xt ;
: immediate   latest 'xt dup @ 100000 or swap ! ;

: law,   004000 + code, ;
: lwc,   104000 + code, ;
: jmp,   010000 + code, ;
: jms,   034000 + code, ;
: lac,   060000 + code, ;
: )      100000 + ;
: #      ;

: exit   latestxt ) jmp, ;
: near?   -1 ;
: compile,   near? if jms, else # ) jms, then ;
: push,   ['] push compile, ;

: literal
   push,
   dup 0 4000 within if law, exit then
   dup -3777 0 within if negate lwc, exit then
   # lac, ; immediate

: number,   number [compile] literal ;
create compiler-state   1 ,  ' compile, , ' number, , ' execute ,  ' noop ,
: ]   compiler-state 'state ! ; immediate
: :   parse-name header,  ] ;
: ;   [compile] exit  [compile] [ ; immediate

variable 'does
: code-here   code here data ;
: create   parse-name header,  here [compile] literal code-here 'does ! [compile] exit ;
: does>   'does @ code dp ! data ; immediate
: variable   create cell allot ;

: ."   compile (dot-quote)  [char] " parse code string, data ; immediate

: [']   ' [compile] literal ; immediate
: [compile]   ' compile, ; immediate
: compile   [compile] [']  compile compile, ; immediate

: ahead   code-here 0 jmp, ; immediate
: then   code-here 010000 + swap ! ; immediate

: begin   code-here ; immediate
: again   jmp, ; immediate

: if   compile 0branch [compile] ahead ; immediate
: else   [compile] ahead swap [compile] then ; immediate
: until   compile 0branch [compile] again ; immediate
: while   [compile] if swap ; immediate
: repeat   [compile] again [compile] then ; immediate

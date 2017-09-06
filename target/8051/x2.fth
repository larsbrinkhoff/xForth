also assembler  hex
h: exit   ret, ;
h: nip   r0 inc, r0 inc, ;
h: 1+   A3 c, ;
h: cell+   A3 c, A3 c, ;

h: if   branch?, if, ;
h: ahead   ahead, ;
h: then   then, ;
h: else   else, ;

h: begin   begin, ;
h: again   again, ;
h: until   branch?, until, ;
h: while   branch?, while, ;
h: repeat   repeat, ;
previous

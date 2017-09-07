also assembler
h: exit   exit, ?page ;
h: nip   sp isz, ;
h: +   sp ) tad, ;
h: and   sp ) and, ;
h: invert   cma, ;
h: 1+   iac, ;
h: cell+   iac, ;
h: 2*   cll, ral, +, ;
h: negate   cma, iac, +, ;
h: cells ;

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

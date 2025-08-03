also assembler
h: exit   exit, ?page ;
h: nip   sp isz, ;
h: drop  sp ) lac, ;
h: +   sp ) add, ;
h: or   sp ) ior, ;
h: xor   sp ) xor, ;
h: and   sp ) and, ;
h: invert   cma, ;
h: negate   cia, ;
h: 1+   iac, ;
h: cell+   iac, ;
h: 1-   -1 # add, ;
h: 2/   1 sar, ;
h: cells ;

h: >r   latest cell/ xam,   s" (>r)" "' comp, ;
h: r>   s" (r>)" "' comp,  latest cell/ xam, ;
h: r@   push,  latest cell/ lac, ;

h: if   0branch, ahead, ;
h: ahead   ahead, ;
h: then   then, ;
h: else   else, ;

h: begin   begin, ;
h: again   again, ;
h: until   0branch, again, ;
h: while   >r 0branch, ahead, r> ;
h: repeat   repeat, ;
previous

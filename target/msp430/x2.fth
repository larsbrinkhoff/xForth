also assembler
h: +   r4 )+ r5 add, ;
h: and   r4 )+ r5 and, ;
h: or   r4 )+ r5 bis, ;
h: xor   r4 )+ r5 xor, ;
h: 2*   r5 rla, ;
h: 2/   r5 rra, ;
h: invert   r5 inv, ;
h: @   r5 ) r5 mov, ;
h: c@   r5 ) r5 .b mov, ;
h: drop   r4 )+ r5 mov, ;
h: exit   ret, ;
h: nip   2# r4 add, ;
h: cell+   2# r5 add, ;
h: 1+   1# r5 add, ;
h: 1-   1# r5 sub, ;
h: negate   r5 inv,  r5 inc, ;
h: >r   r5 push,  r4 )+ r5 mov, ;

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

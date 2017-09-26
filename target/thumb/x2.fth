also assembler
h: exit   {pc} pop, ;
h: dup   dup, ;
h: drop   r7 ) r6 ldr,  4 # r7 addi, ;
h: nip   4 # r7 addi, ;
h: 2*   1 # r6 r6 lsli, ;
h: 2/   1 # r6 r6 asri, ;
h: @   r6 ) r6 ldr, ;
h: c@   r6 ) r6 ldrb, ;
h: 1+   1 # r6 addi, ;
h: 1-   1 # r6 subi, ;
h: cell+   4 # r6 addi, ;
h: negate   r6 r6 neg, ;
h: invert   r6 r6 mvn, ;
h: 0<>   r6 r5 neg,  r6 r6 sbc, ;

h: if   branch?, if, ;
h: ahead   ahead, ;
h: then   then, ;
h: else   else, ;

h: begin   begin, ;
h: again   again, ;
h: until   branch?, until, ;
h: while   while, ;
h: repeat   repeat, ;
previous

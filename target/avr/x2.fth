also assembler
h: exit   ret, ;
h: exitint  reti, ;
h: nip   2 # r28 adiw, ;
h: cell+   2 # r26 adiw, ;
h: 1+   1 # r26 adiw, ;
h: 1-   1 # r26 sbiw, ;

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

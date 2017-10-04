also assembler
h: exit   ." }" cr ;

h: if   ."   if(*sp++) {" cr ;
h: ahead   ."   if(1) {" cr ;
h: then   ."   }" cr ;
h: else   ."   } else {" cr ;

h: begin   ;
h: again   ;
h: until   ;
h: while   ;
h: repeat   ;
previous

only forth definitions

: more?   refill 0= abort" End of file inside CODE."
   source s" end-code" compare ;
: code-lines   begin more? while source type cr repeat ." }" cr ;

also meta definitions

h: code    code code-lines ;

only forth also meta also compiler definitions previous

hex
01000 org

code cold
   FF # ldx,
   txs,
   10 # ldx,
   ahead,
end-code

code dup
   dex,
   stack-hi 1+ ,x lda,
   stack-hi ,x sta,
   stack-lo 1+ ,x lda,
   stack-lo ,x sta,
   rts,
end-code

: drop   drop ;

code >r
   pla,
   w sta,
   pla,
   w 1+ sta,
   w inc,
   0=, if,
     w 1+ inc,
   then,
   stack-hi ,x lda,
   pha,
   stack-lo ,x lda,
   pha,
   inx,
   w ) jmp,
end-code

code r>
   pla,
   w sta,
   pla,
   w 1+ sta,
   w inc,
   0=, if,
     w 1+ inc,
   then,
   dex,
   pla,
   stack-lo ,x sta,
   pla,
   stack-hi ,x sta,
   w ) jmp,
end-code

code r@
   txa,
   tsx,
   103 ,x ldy,
   w sty,
   104 ,x ldy,
   tax,
   dex,
   stack-hi ,x sty,
   w lda,
   stack-lo ,x sta,
   rts,
end-code

code over
   dex,
   stack-hi 2 + ,x lda,
   stack-hi ,x sta,
   stack-lo 3 + ,x lda,
   stack-lo ,x sta,
   rts,
end-code

code +
   stack-lo ,x lda,
   clc,
   stack-lo 1+ ,x adc,
   stack-lo 1+ ,x sta,
   stack-hi ,x lda,
   stack-hi 1+ ,x adc,
   stack-hi 1+ ,x sta,
   inx,
   rts,
end-code

code xor
   stack-lo ,x lda,
   stack-lo 1+ ,x eor,
   stack-lo 1+ ,x sta,
   stack-hi ,x lda,
   stack-hi 1+ ,x eor,
   stack-hi 1+ ,x sta,
   inx,
   rts,
end-code

code and
   stack-lo ,x lda,
   stack-lo 1+ ,x and,
   stack-lo 1+ ,x sta,
   stack-hi ,x lda,
   stack-hi 1+ ,x and,
   stack-hi 1+ ,x sta,
   inx,
   rts,
end-code

code or
   stack-lo ,x lda,
   stack-lo 1+ ,x ora,
   stack-lo 1+ ,x sta,
   stack-hi ,x lda,
   stack-hi 1+ ,x ora,
   stack-hi 1+ ,x sta,
   inx,
   rts,
end-code

code 2*   
   stack-lo ,x asl,
   stack-hi ,x rol,
   rts,
end-code

code 2/   
   stack-hi ,x lda,
   80 # cmp,
   stack-hi ,x ror,
   stack-lo ,x ror,
   rts,
end-code

code invert
   stack-lo ,x lda,
   FF # eor,
   stack-lo ,x sta,
   stack-hi ,x lda,
   FF # eor,
   stack-hi ,x sta,
   rts,
end-code

code @
   stack-lo ,x lda,
   w sta,
   stack-hi ,x lda,
   w 1+ sta,
   0 # ldy,
   w ),y lda,
   stack-lo ,x sta,
   iny,
   w ),y lda,
   stack-hi ,x sta,
   rts,
end-code

code c@
   stack-lo ,x lda,
   w sta,
   stack-hi ,x lda,
   w 1+ sta,
   0 # ldy,
   w ),y lda,
   stack-lo ,x sta,
   0 # lda,
   stack-hi ,x sta,
   rts,
end-code

: 2drop   2drop ;

code !
   stack-lo ,x lda,
   w sta,
   stack-hi ,x lda,
   w 1+ sta,
   0 # ldy,
   stack-lo 1+ ,x lda,
   w ),y sta,
   iny,
   stack-hi 1+ ,x lda,
   w ),y sta,
   inx,
   inx,
   rts,
end-code

code c!
   stack-lo ,x lda,
   w sta,
   stack-hi ,x lda,
   w 1+ sta,
   0 # ldy,
   stack-lo 1+ ,x lda,
   w ),y sta,
   inx,
   inx,
   rts,
end-code

code swap
   stack-lo ,x ldy,
   stack-lo 1+ ,x lda,
   stack-lo ,x sta,
   stack-lo 1+ ,x sty,
   stack-hi ,x ldy,
   stack-hi 1+ ,x lda,
   stack-hi ,x sta,
   stack-hi 1+ ,x sty,
   rts,
end-code

code nip
   inx,
   rts,
end-code

code branch?
   inx,
   stack-lo 1- ,x lda,
   stack-hi 1- ,x ora,
   rts,
end-code

: ?dup   dup if dup then ;
: +!   dup >r @ + r> ! ;
: 1+   1 + ;
: negate   invert 1+ ;
: -   negate + ;
: 0=   if 0 else -1 then ;
: 0<>   0= 0= ;
: =   - 0= ;
: <>   - 0<> ;

: 1-   1 - ;
: cell+   2 + ;

code bye
   brk,
end-code

code panic
   1 # lda,
   0F000 sta,
end-code

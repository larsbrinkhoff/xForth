hex

code cold
   FF # ldx,
   txs,
   10 # ldx,
   ahead,
end-code

code dup
   stack-lo ,x lda,
   stack-hi ,x ldy,
label pushay
   dex,
label storay
   stack-lo ,x sta,
   stack-hi ,x sty,
   rts,
end-code

code >r
   pla,
   w sta,
   pla,
   tay,
   stack-hi ,x lda,
   pha,
   stack-lo ,x lda,
   pha,
   inx,
label jumpw
   tya,
   pha,
   w lda,
   pha,
   rts,
end-code

code r>
   pla,
   w sta,
   pla,
   tay,
   dex,
   pla,
   stack-lo ,x sta,
   pla,
   stack-hi ,x sta,
   jumpw jmp,
end-code

code r@
   txa,
   tsx,
   103 ,x ldy,
   w sty,
   104 ,x ldy,
   tax,
   w lda,
   pushay jmp,
end-code

code over
   stack-hi 1+ ,x ldy,
   stack-lo 1+ ,x lda,
   pushay jmp,
end-code

code xor
   stack-hi ,x lda,
   stack-hi 1+ ,x eor,
   tay,
   stack-lo ,x lda,
   stack-lo 1+ ,x eor,
   pushay jmp,
end-code

code and
   stack-hi ,x lda,
   stack-hi 1+ ,x and,
   tay,
   stack-lo ,x lda,
   stack-lo 1+ ,x and,
   pushay jmp,
end-code

code or
   stack-hi ,x lda,
   stack-hi 1+ ,x ora,
   tay,
   stack-lo ,x lda,
   stack-lo 1+ ,x ora,
   pushay jmp,
end-code

code 2*   
   stack-lo ,x asl,
   stack-hi ,x rol,
   rts,
end-code

code 2/   
   stack-hi ,x lda,
   a asl,
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

code fetchw
   stack-lo ,x lda,
   w sta,
   stack-hi ,x lda,
   w 1+ sta,
   0 # ldy,
   w ),y lda,
   rts,
end-code

code @
   ' fetchw jsr,
   iny,
   stack-lo ,x sta,
   w ),y lda,
   stack-hi ,x sta,
   rts,
end-code

code c@
   ' fetchw jsr,
   storay jmp,
end-code

: negate   invert [  \ Fall through.

code 1+
   stack-lo ,x inc,
   0=, if,
     stack-hi ,x inc,
   then,
   rts,
end-code

: 1-   1 [  \ Fall through.
: -   negate [  \ Fall through.

code +
   stack-lo ,x lda,
   clc,
   stack-lo 1+ ,x adc,
   stack-lo 1+ ,x sta,
   stack-hi ,x lda,
   stack-hi 1+ ,x adc,
   inx,
   stack-hi ,x sta,
   rts,
end-code

: +!   dup >r @ + r> [  \ Fall through.

code !
   ' fetchw jsr,
   stack-lo 1+ ,x lda,
   w ),y sta,
   iny,
   stack-hi 1+ ,x lda,
label stora
   w ),y sta,
   inx,
   inx,
   rts,
end-code

code c!
   ' fetchw jsr,
   stack-lo 1+ ,x lda,
   stora jmp,
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

: nip   swap drop ;

code branch?
   inx,
   stack-lo 1- ,x lda,
   stack-hi 1- ,x ora,
   rts,
end-code

: ?dup   dup if dup then ;

: =   - [  \ Fall through.

code 0=
   0 # ldy,
   stack-lo ,x lda,
   stack-hi ,x ora,
   0=, if,
     dey,
   then,
label pushyy
   stack-lo ,x sty,
   stack-hi ,x sty,
   rts,
end-code

code 0<
   0 # ldy,
   stack-hi ,x asl,
   cs, if,
     dey,
   then,
   pushyy jmp,
end-code

: <>   - [  \ Fall through.
: 0<>   0= 0= ;
: cell+   1+ 1+ ;

code bye
   brk,
end-code

code panic
   1 # lda,
   0F000 sta,
end-code

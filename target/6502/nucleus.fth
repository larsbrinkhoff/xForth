hex
01000 org

code cold
   FF # ldx,
   txs,
   10 # ldx,
   ahead,
end-code

code dup
   tos lda,
   tos 1+ ,x ldy,
label pushay
   dex,
label storay
   stack-lo ,x sta,
   stack-hi ,x sty,
   rts,
end-code

code drop
   inx,
   stack-lo ,x lda,
   stack-hi ,x ldy,
label storetos
   tos sta,
   tos 1+ sty,
   rts,
end-code

code 2drop
   inx,
   ' drop jmp,
end-code

code >r
   pla,
   w sta,
   pla,
   tay,
   tos lda,
   pha,
   tos 1+ lda,
   pha,
   tya,
   pha,
   w lda,
   pha,
   ' drop jmp,
end-code

code r>
   ' dup jsr,
   pla,
   w sta,
   pla,
   tay,
   dex,
   pla,
   tos sta,
   pla,
   tos 1+ ,x sta,
   tya,
   pha,
   w lda,
   pha,
   rts,
end-code

code r@
   ' dup jsr,
   txa,
   tsx,
   103 ,x ldy,
   w sty,
   104 ,x ldy,
   tax,
   w lda,
   storetos jmp,
end-code

code over
   ' dup jsr,
   stack-hi 1+ ,x lda,
   stack-lo 1+ ,x ldy,
   storetos jmp,
end-code

code +
   tos lda,
   clc,
   stack-lo ,x adc,
   tos sta,
   tos 1+ ,x lda,
   stack-hi ,x adc,
label pusha
   tos 1+ sta,
   inx,
   rts,
end-code

code xor
   tos lda,
   stack-lo ,x eor,
   tos sta,
   tos 1+ ,x lda,
   stack-hi ,x eor,
   pusha jmp,
end-code

code and
   tos lda,
   stack-lo ,x and,
   tos sta,
   tos 1+ ,x lda,
   stack-hi ,x and,
   pusha jmp,
end-code

code or
   tos lda,
   stack-lo ,x ora,
   tos sta,
   tos 1+ ,x lda,
   stack-hi ,x ora,
   pusha jmp,
end-code

code 2*   
   tos asl,
   tos 1+ rol,
   rts,
end-code

code 2/   
   tos 1+ lda,
   a asl,
   tos 1+ ror,
   tos ror,
   rts,
end-code

code invert
   tos lda,
   FF # eor,
   tos sta,
   tos 1+ lda,
   FF # eor,
   tos 1+ sta,
   rts,
end-code

code @
   w stx,
   0 # ldy,
   tos ),y lda,
   tax,
   iny,
   tos ),y lda,
   tos stx,
   tos 1+ sta,
   w ldx,
   rts,
end-code

code c@
   0 # ldy,
   tos ),y lda,
   storetos jmp,
end-code

code c!
   0 # ldy,
label cstore
   stack-lo ,x lda,
   tos ),y sta,
   ' 2drop jmp,
end-code

code !
   1 # ldy,
   stack-hi ,x lda,
   tos ),y sta,
   dey,
   cstore jmp,
end-code

code swap
   tos ldy,
   stack-lo ,x lda,
   tos sta,
   stack-lo ,x sty,
   tos ldy,
   stack-hi ,x lda,
   tos sta,
   stack-hi ,x sty,
   rts,
end-code

code branch?
   tos lda,
   tos 1+ ora,
   php,
   ' drop jsr,
   plp,
   rts,
end-code

: ?dup   dup if dup then ;
: +!   dup >r @ + r> ! ;

code 1+
   tos inc,
   0=, if,
     tos 1+ inc,
   then,
   rts,
end-code

: negate   invert 1+ ;
: -   negate + ;
: 0=   if 0 else -1 then ;
: 0<>   0= 0= ;
: =   - 0= ;
: <>   - 0<> ;

: 1-   1 - ;
: cell+   1+ 1+ ;

code bye
   brk,
end-code

code panic
   1 # lda,
   0F000 sta,
end-code

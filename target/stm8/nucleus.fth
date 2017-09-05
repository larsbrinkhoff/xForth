hex
08000 org

code cold
   \ Interrupt vectors.
   08080 int, 0 int, 0 int, 0 int, 0 int, 0 int, 0 int, 0 int,
   0 int, 0 int, 0 int, 0 int, 0 int, 0 int, 0 int, 0 int,
   0 int, 0 int, 0 int, 0 int, 0 int, 0 int, 0 int, 0 int,
   0 int, 0 int, 0 int, 0 int, 0 int, 0 int, 0 int, 0 int,
   17FF # ldx,
   x ldsp,
   1700 # ldx,
   ahead, nop, \ Leave room to make this a JP.
end-code

code dup
   x ldy,
   (y) ldy,
label pushy
   x decw,
   x decw,
   (x) sty,
   ret,
end-code

: drop   drop ;

code >r
   exgw,
   1 ,sp) ldx,
   x pushw,
   y ldx,
   (x) ldx,
   exgw,
   3 ,sp) sty,
   ' drop jra,
   ret,
end-code

code r>
   3 ,sp) ldy,
   pushy callr,
   y popw,
   2 addsp,
   (y) jp,
end-code

code r@
   3 ,sp) ldy,
   pushy jra,
end-code

code over
   x ldy,
   2 ,y) ldy,
   pushy jra,
end-code

code +
   1 ,x) lda,
   3 ,x) add,
   3 ,x) sta,
   (x) lda,
   2 ,x) adc,
label store
   2 ,x) sta,
   ' drop jra,
end-code

code xor
   1 ,x) lda,
   3 ,x) xor,
   3 ,x) sta,
   (x) lda,
   2 ,x) xor,
   store jra,
end-code

code and
   1 ,x) lda,
   3 ,x) and,
   3 ,x) sta,
   (x) lda,
   2 ,x) and,
   store jra,
end-code

code or
   1 ,x) lda,
   3 ,x) or,
   3 ,x) sta,
   (x) lda,
   2 ,x) or,
   store jra,
end-code

code 2*   
   x ldy,
   (y) ldy,
   y sllw,
   (x) sty,
   ret,
end-code

code 2/   
   x ldy,
   (y) ldy,
   y sraw,
   (x) sty,
   ret,
end-code

code invert
   x ldy,
   (y) ldy,
   y cplw,
   (x) sty,
   ret,
end-code

code @
   x ldy,
   (y) ldy,
   (y) ldy,
   (x) sty,
   ret,
end-code

code c@
   x ldy,
   (y) ldy,
   (y) lda,
   (x) clr,
   1 ,x) sta,
   ret,
end-code

code 2drop
   1C c, 00 c, 04 c, \ 4 # addx,
   ret,
end-code

code !
   x ldy,
   (y) ldy,
   x pushw,
   2 ,x) ldx,
   (y) stx,
   x popw,
   ' 2drop jra,
end-code

code c!
   x ldy,
   (y) ldy,
   3 ,x) lda,
   (y) sta,
   ' 2drop jra,
end-code

code swap
   x ldy,
   2 ,x) ldx,
   x pushw,
   y ldx,
   (x) ldx,
   exgw,
   2 ,x) sty,
   y popw,
   (x) sty,
   ret,
end-code

code nip
   x ldy,
   (y) ldy,
   x incw,
   x incw,
   (x) sty,
   ret,
end-code

code branch?
   x ldy,
   x incw,
   x incw,
   (y) ldy,
   ret,
end-code

: ?dup   dup if dup then ;
: +!   dup >r @ + r> ! ;
: 1+   1 + ;
: negate   invert 1+ ;
: -   negate + ;
: 0=   -1 swap if 1+ then ;
: 0<>   0= 0= ;
: =   - 0= ;
: <>   - 0<> ;
: 1-   1 - ;
: cell+   1+ 1+ ;

code bye
   break,
end-code

code panic
   05 c,
end-code

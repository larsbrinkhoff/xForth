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
   tos ldy,
   x decw,
   x decw,
   (x) sty,
   ret,
end-code

code !
   x ldy,
   (y) ldy,
   tos ) sty,
   \ Fall through to "2drop".
end-code

code 2drop
   x incw,
   x incw,
   \ Fall through to "drop".
end-code

code drop
   x ldy,
   (y) ldy,
   x incw,
   x incw,
label storetos
   tos sty,
   ret,
end-code

code c!
   1 ,x) lda,
   tos ) sta,
   ' 2drop jra,
end-code

code branch?
   tos ldy,
   y pushw,
   ' drop callr,
   y popw,
   y tnzw,
   ret,
end-code

code >r
   exgw,
   1 ,sp) ldx,
   x pushw,
   tos ldx,
   exgw,
   3 ,sp) sty,
   ' drop jra,
end-code

code r>
   ' dup callr,
   3 ,sp) ldy,
   tos sty,
   y popw,
   2 addsp,
   (y) jp,
end-code

code r@
   ' dup callr,
   3 ,sp) ldy,
   storetos jra,
end-code

code over
   ' dup callr,
   x ldy,
   2 ,y) ldy,
   storetos jra,
end-code

code +
   x ldy,
   (x) ldy,
   72 c, B9 c, tos , \ tos addy,
   x incw,
   x incw,
   storetos jra,
end-code

code xor
   (x) lda,
   tos xor,
   tos sta,
   x incw,
   (x) lda,
   tos 1+ xor,
label stora
   tos 1+ sta,
   x incw,
   ret,
end-code

code and
   (x) lda,
   tos and,
   tos sta,
   x incw,
   (x) lda,
   tos 1+ and,
   stora jra,
end-code

code or
   (x) lda,
   tos or,
   tos sta,
   x incw,
   (x) lda,
   tos 1+ or,
   stora jra,
end-code

code 2*
   tos ldy,
   y sllw,
   storetos jra,
end-code

code 2/   
   tos ldy,
   y sraw,
   storetos jra,
end-code

code invert
   tos ldy,
   y cplw,
label storetos2
   tos sty,
   ret,
end-code

code @
   tos ) ldy,
   storetos2 jra,
end-code

code c@
   tos ) lda,
   tos clr,
   tos 1+ sta,
   ret,
end-code

code swap
   x ldy,
   (x) ldx,
   x pushw,
   y ldx,
   tos ldx,
   exgw,
   (x) sty,
   y popw,
   storetos2 jra,
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

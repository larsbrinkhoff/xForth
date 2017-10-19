hex
0 org

also assembler
   \ Interrupt vectors.
   ahead, nop,
   reti, 7 allot
   reti, 7 allot
   reti, 7 allot
   reti, 7 allot \ Breakpoint here for successful test.
   reti, 7 allot \ Breakpoint here for failed test.
end-code

code cold
   then,
   FF # r0 movi,
   7 # sp movi,
   ahead, nop,
end-code

code dup
   r0 dec,
   dph lda,
   @r0 xsta,
   r0 dec,
   dpl lda,
   @r0 xsta,
   ret,
end-code

code r>
   ' dup acall,
   3 pop,
   2 pop,
   dph pop,
   dpl pop,
   2 push,
   3 push,
   ret,
end-code

code r@
   ' dup acall,
   sp r1 ldm,
   r1 dec,
   r1 dec,
   @r1 dph stm,
   r1 dec,
   @r1 dpl stm,
   ret,
end-code

code swap
   @r0 xlda,
   r2 sta,
   r0 inc,
   @r0 xlda,
   r3 sta,
label semiswap
   dph lda,
   @r0 xsta,
   r0 dec,
   dpl lda,
   @r0 xsta,
   r3 dph stm,
   r2 dpl stm,
   ret,
end-code

code over
   @r0 xlda,
   r2 sta,
   r0 inc,
   @r0 xlda,
   r3 sta,
   r0 dec,
   r0 dec,
   semiswap sjmp,
end-code

code invert
   FF # dpl xrlm,
   FF # dph xrlm,
   ret,
end-code

: negate   invert 1+ ;
: 1-   1 [  \ Fall through.
: -   negate [  \ Fall through.

code +
   @r0 xlda,
   r0 inc,
   dpl add,
   dpl sta,
   @r0 xlda,
   r0 inc,
   dph addc,
   dph sta,
   ret,
end-code

code xor
   @r0 xlda,
   r0 inc,
   a dpl xrlm,
   @r0 xlda,
   r0 inc,
   a dph xrlm,
   ret,
end-code

code and
   @r0 xlda,
   r0 inc,
   a dpl anlm,
   @r0 xlda,
   r0 inc,
   a dph anlm,
   ret,
end-code

code or
   @r0 xlda,
   r0 inc,
   a dpl orlm,
   @r0 xlda,
   r0 inc,
   a dph orlm,
   ret,
end-code

code 2*   
   dpl lda,
   dpl add,
   dpl sta,
   dph lda,
   rlc,
   dph sta,
   ret,
end-code

code 2/   
   dph lda,
   rlc,
   dph lda,
   rrc,
   dph sta,
   dpl lda,
   rrc,
   dpl sta,
   ret,
end-code

code @
   @dptr xlda,
   r2 sta,
   A3 c, \ dptr inc,
   @dptr xlda,
   dph sta,   
   r2 dpl stm,
   ret,
end-code

code c@
   @dptr xlda,
   dpl sta,
   0 # dph movi,
   ret,
end-code

code c!
   @r0 xlda,
   @dptr xsta,
   \ Fall through to "2drop".
end-code

code 2drop
   r0 inc,
   r0 inc,
   \ Fall through to "drop".
end-code

code drop
   @r0 xlda,
   dpl sta,
   r0 inc,
   @r0 xlda,
   dph sta,
   r0 inc,
   ret,
end-code

code >r
   3 pop,
   2 pop,
   dpl push,
   dph push,
   2 push,
   3 push,
   ' drop sjmp,
end-code

: +!   dup >r @ + r> [  \ Fall through.

code !
   @r0 xlda,
   r0 inc,
   @dptr xsta,
   A3 c, \ dptr inc,
   @r0 xlda,
   r0 inc,
   @dptr xsta,
   ' drop sjmp,
end-code

code swap
   @r0 xlda,
   r2 sta,
   r0 inc,
   @r0 xlda,
   r3 sta,
   dph lda,
   @r0 xsta,
   r0 dec,
   dpl lda,
   @r0 xsta,
   r3 dph stm,
   r2 dpl stm,
   ret,
end-code

code branch?
   dpl lda,
   dph orl,
   r4 sta,
   ' drop acall,
   r4 lda,
   ret,
end-code

code 0<
   dph lda,
   rlc,
   cs, if,
     FF # dph movi,
     FF # dpl movi,
   else,
     0 # dph movi,
     0 # dpl movi,
   then,
   ret,
end-code

: ?dup   dup if dup then ;
: =   - [  \ Fall through.
: 0=   if 0 else -1 then ;
: <>   - [  \ Fall through.
: 0<>   0= 0= ;

code bye
   1B ljmp,
end-code

code panic
   23 ljmp,
end-code

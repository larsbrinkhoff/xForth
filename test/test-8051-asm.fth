require target/8051/asm.fth

hex

: fail? ( c a -- a' f ) 1- tuck c@ <> ;
: .fail   cr ." FAIL: " source 5 - type cr ;
: ?fail   fail? if .fail abort then ;
: check   here begin depth 1- while ?fail repeat drop ;

.( Assembler test: )
code assembler-test

   nop,                     00 check
   rr,                      03 check
   rrc,                     13 check
   ret,                     22 check
   rl,                      23 check
   reti,                    32 check
   rlc,                     33 check
   jmp,                     73 check
   div,                     84 check
   mul,                     A4 check
   swap,                    C4 check
   da,                      D4 check

   a inc,                   04 check
   0 inc,                   05 00 check
   @r0 inc,                 06 check
   @r1 inc,                 07 check
   r0 inc,                  08 check
   r7 inc,                  0F check

   a dec,                   14 check
   1 # add,                 24 01 check
   @r0 addc,                36 check
   @r1 orl,                 47 check
   r0 anl,                  58 check
   r1 xrl,                  69 check
   FF # subb,               94 FF check
   1 xch,                   C5 01 check
   @r0 xchd,                D6 check
   a clr,                   E4 check
   a cpl,                   F4 check

   a 1 orlm,                42 1 check
   2 # 1 orlm,              43 1 2 check
   a 3 anlm,                52 3 check
   5 # 4 xrlm,              63 4 5 check

   0 # a movi,              74 00 check
   1 # sp movi,             75 81 01 check
   2 # @r0 movi,            76 02 check
   FF # r7 movi,            7F FF check
   1 2 stm,                 85 01 02 check
   @r0 psw stm,             86 D0 check
   r0 acc stm,              88 E0 check
   1 @r1 ldm,               A7 01 check
   2 r1 ldm,                A9 02 check
   dpl lda,                 E5 82 check
   @r1 lda,                 E7 check
   r0 lda,                  E8 check
   dph sta,                 F5 83 check
   @r0 sta,                 F6 check
   r7 sta,                  FF check
   @dptr xlda,              E0 check
   @r0 xlda,                E2 check
   @dptr xsta,              F0 check
   @r1 xsta,                F3 check

   1234 # dptr mov,         90 12 34 check
 \ @a+pc movc,              93 check
 \ @a+dptr movc,            83 check

   0 push,                  C0 00 check
   FF pop,                  D0 FF check

   0 ajmp,                  01 00 check
   1 ajmp,                  01 01 check
   FF ajmp,                 01 FF check
   100 ajmp,                21 00 check
   400 ajmp,                81 00 check
   0 acall,                 11 00 check
   100 acall,               31 00 check

   FF ljmp,                 02 00 FF check
   100 ljmp,                02 01 00 check
   FF00 lcall,              12 FF 00 check

   create l \ label
   l jc,                    40 FE check
   l jnc,                   50 FC check
   l jz,                    60 FA check
   l jnz,                   70 F8 check
   l sjmp,                  80 F6 check

   ahead, nop, then,        80 01 00 check
   0=, if, nop, then,       70 01 00 check
   begin, again,            80 FE check
   begin, 0<>, until,       60 FE check

end-code
.( PASS ) cr

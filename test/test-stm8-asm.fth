require target/stm8/asm.fth

hex

: fail? ( c a -- a' f ) 1- tuck c@ <> ;
: .fail   cr ." FAIL: " source 5 - type cr ;
: ?fail   fail? if .fail abort then ;
: check   here begin depth 1- while ?fail repeat drop ;

.( Assembler test: )
code assembler-test

   exgw,                    51 check
   iret,                    80 check
   ret,                     81 check
   trap,                    83 check
   retf,                    87 check
   break,                   8B check
   ccf,                     8C check
   halt,                    8E check
   wfi,                     8F check
   wfe,                  72 8F check
   rim,                     9A check
   sim,                     9B check
   rcf,                     98 check
   scf,                     99 check
   rvf,                     9C check
   nop,                     9D check

   123456 int,              82 12 34 56 check

   a neg,                   40 check
   12 cpl,                  33 12 check
   1234 srl,             72 54 12 34 check
   (x) rrc,                 76 check
   (y) sra,              90 77 check
   0 ,x) sll,               68 00 check
   1234 ,x) rlc,         72 49 12 34 check
   0 ,y) neg,            90 60 00 check
   1234 ,y) neg,         90 40 12 34 check
   0 ,sp) dec,              0A 00 check
   0 ) inc,              92 3C 00 check
   1234 ) tnz,           72 3D 12 34 check
   0 ),x) swap,          92 6E 00 check
   1234 ),x) clr,        72 6F 12 34 check
   0 ),y) neg,           91 60 00 check

   xl exg,                  41 check
   yl exg,                  61 check
   1 exg,                   31 00 01 check

   0 # sub,                 A0 00 check
   12 cp,                   B1 12 check
   1234 sbc,                C2 12 34 check
   1234 cpw,                A3 12 34 check
   (x) cpw,                 F3 check
   (y) and,              90 F4 check
   0 ,x) bcp,               E5 00 check
   1234 ,x) lda,            D6 12 34 check
   0 ,y) sta,            90 E7 00 check
   1234 ,y) xor,         90 D8 12 34 check
   0 ,sp) adc,              19 00 check
   0 ) or,               92 CA 00 check
   1234 ) add,           72 CB 12 34 check
   0 ),x) jp,            92 DC 00 check
   1234 ),x) call,       72 DD 12 34 check
   0 call,                  CD 00 00 check
   0 ),y) sub,           91 D0 00 check

   a ldxl,                  97 check
   a ldxh,                  95 check
   a ldyl,               90 97 check
   a ldyh,               90 95 check
   xl lda,                  9B check
   xh lda,                  9F check
   yl lda,               90 9B check
   yh lda,               90 9F check

   0 # ldx,                 AE 00 00 check
   0 ldx,                   BE 00 check
   1234 ldx,                CE 12 34 check
   (x) ldx,                 FE check
   0 ,x) ldx,               EE 00 check
   1234 ,x) ldx,            DE 12 34 check
   0 ,sp) ldx,              1E 00 check
   0 ) ldx,              92 CE 00 check
   1234 ) ldx,           72 CE 12 34 check
   0 ),x) ldx,           92 DE 00 check
   1234 ),x) ldx,        72 DE 12 34 check

   0 stx,                   BF 0 check
   1234 stx,                CF 12 34 check
   (y) stx,              90 FF check
   0 ,y) stx,            90 EF 00 check
   1234 ,y) stx,         90 DF 12 34 check
   0 ,sp) stx,              1F 00 check
   0 ) stx,              92 CF 00 check
   1234 ) stx,           72 CF 12 34 check
   0 ),y) stx,           91 DF 00 check

   0 sty,                90 BF 0 check
   1234 sty,             90 CF 12 34 check
   (x) sty,                 FF check
   0 ,x) sty,               EF 00 check
   1234 ,x) sty,            DF 12 34 check
   0 ,sp) sty,              17 00 check
   0 ) sty,              91 CF 00 check
   0 ),x) sty,           92 DF 00 check
   1234 ),x) sty,        72 DF 12 34 check

   0 # ldy,              90 AE 00 00 check
   0 ldy,                90 BE 00 check
   1234 ldy,             90 CE 12 34 check
   (y) ldy,              90 FE check
   0 ,y) ldy,            90 EE 00 check
   1234 ,y) ldy,         90 DE 12 34 check
   0 ,sp) ldy,              16 00 check
   0 ) ldy,              91 CE 00 check
   0 ),y) ldy,           91 DE 00 check

   y ldx,                   93 check
   x ldy,                90 93 check
   sp ldx,                  96 check
   sp ldy,               90 96 check
   x ldsp,                  94 check
   y ldsp,               90 94 check

   x decw, (x) sty,         5A FF check
   x pushw, y ldx,          89 93 check

   a pop,                   84 check
   cc pop,                  86 check
   1 pop,                   32 00 01 check
   0 # push,                4B 00 check
   a push,                  88 check
   cc push,                 8A check
   1 push,                  3B 00 01 check

(* 0 # 1 mov,               35 00 00 01 check
   1 2 mov,                 45 01 02 check
   1234 0 mov,              55 00 00 12 34 check
   0 1234 mov,              55 12 34 00 00 check *)

   here callr,              AD FE check
   here jra,                20 FE check

   create l \ label
   l jrf,                   21 FE check
   l jrugt,                 22 FC check
   l jrule,                 23 FA check
   l jrnc,                  24 F8 check
   l jrc,                   25 F6 check
   l jrne,                  26 F4 check
   l jreq,                  27 F2 check
   l jrnv,                  28 F0 check
   l jrpl,                  2A EE check
   l jrmi,                  2B EC check
   l jrsgt,                 2C EA check
   l jrsle,                 2D E8 check
   l jrsge,                 2E E6 check
   l jrslt,                 2F E4 check

   x rrwa,                  01 check
   y rlwa,               90 02 check
   x mul,                   42 check
   y mul,                90 42 check
   x negw,                  50 check
   y negw,               90 50 check
   exgw,                    51 check
   y cplw,               90 53 check
   x srlw,                  54 check
   y rrcw,               90 56 check
   x sraw,                  57 check
   y sllw,               90 58 check
   x rlcw,                  59 check
   y decw,               90 5A check
   x incw,                  5C check
   y tnzw,               90 5D check
   x swapw,                 5E check
   y clrw,               90 5F check
   x div,                   62 check
   y div,                90 62 check
   divw,                    65 check
   x popw,                  85 check
   y popw,               90 85 check
   x pushw,                 89 check
   y pushw,              90 89 check

   ahead, nop, then,        20 01 9D check
   0=, if, nop, then,       26 01 9D check
   begin, again,            20 FE check
   begin, 0<>, until,       27 FE check
end-code
.( PASS ) cr

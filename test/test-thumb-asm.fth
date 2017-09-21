\ Test ARM Thumb assembler.

require target/thumb/asm.fth

: w@ ( a -- u ) dup c@ swap 1+ c@ 8 lshift + ;
: fail? ( c a -- a' f ) 2 - tuck w@ <> ;
: .fail   cr ." FAIL: " source 5 - type cr ;
: ?fail   fail? if .fail abort then ;
: check   here begin depth 1- while ?fail repeat drop ;

.( Assembler test: )
code assembler-test
   hex

   1 # addsp,               B001 check
   -1 # addsp,              B0FF check
   0 # bkpt,                BE00 check
   FF # svc,                DFFF check
   1 # udf,                 DE01 check
   {r0} push,               B401 check
   {lr} push,               B500 check
   {pc} pop,                BD00 check
   {r0-r7, pc} pop,         BDFF check

   00 # r0 movi,            2000 check
   00 # r7 cmpi,            2F00 check
   FF # r0 addi,            30FF check
   FF # r7 subi,            3FFF check

   0 # r0 r0 lsli,          0000 check
   r0 r1 mov,               0001 check
   0 # r1 r0 lsri,          0808 check
   1F # r0 r0 asri,         17C0 check

   r0 r0 and,               4000 check
   r0 r1 eor,               4041 check
   r1 r0 lsl,               4088 check
   r0 r2 lsr,               40C2 check
   r3 r0 asr,               4118 check
   r0 r4 adc,               4144 check
   r5 r0 sbc,               41A8 check
   r0 r6 ror,               41C6 check
   r7 r0 tst,               4238 check
   r0 r0 neg,               4240 check
   r0 r0 cmp,               4280 check
   r0 r0 cmn,               42C0 check
   r0 r0 orr,               4300 check
   r0 r0 mul,               4340 check
   r0 r0 bic,               4380 check
   r0 r0 mvn,               43C0 check

   r0 r1 sxth,              B201 check
   r2 r3 sxtb,              B253 check
   r4 r5 uxth,              B2A5 check
   r6 r7 uxtb,              B2F7 check

   pc r0 movh,              4678 check
   r0 pc movh,              4687 check
   nop,                     46C0 check
   r0 bx,                   4700 check
   lr bx,                   4770 check
   r1 blx,                  4788 check

   r0 r0 r1 add,            1801 check
   r0 r1 r0 add,            1808 check
   r1 r0 r0 sub,            1A40 check

   r1 ) r0 ldr,             6808 check
   4 r1 )# r0 ldr,          6848 check
   r2 r1 +) r0 ldr,         5888 check
   here 2 + r7 ldr,         4F00 check
   4 sp) r0 ldr,            9801 check

   1 r1 )# r0 ldrb,         7848 check
   r2 r1 +) r0 ldrb,        5C88 check
   r2 r1 +) r0 ldrsb,       5688 check

   2 r1 )# r0 ldrh,         8848 check
   r2 r1 +) r0 ldrh,        5A88 check
   r2 r1 +) r0 ldrsh,       5E88 check

   r1 ) r0 str,             6008 check
   4 r1 )# r0 str,          6048 check
   r2 r1 +) r0 str,         5088 check
   4 sp) r0 str,            9001 check

   1 r1 )# r0 strb,         7048 check
   r2 r1 +) r0 strb,        5488 check

   2 r1 )# r0 strh,         8048 check
   r2 r1 +) r0 strh,        5288 check

   here b,                  E7FE check
   here bl,                 F7FF FFFE check

   create l \ label
   l beq,                   D0FE check
   l bne,                   D1FD check
   l bcs,                   D2FC check
   l bcc,                   D3FB check
   l bmi,                   D4FA check
   l bpl,                   D5F9 check
   l bvs,                   D6F8 check
   l bvc,                   D7F7 check
   l bhi,                   D8F6 check
   l bls,                   D9F5 check
   l bge,                   DAF4 check
   l blt,                   DBF3 check
   l bgt,                   DCF2 check
   l ble,                   DDF1 check

   ahead, then,             E7FF check
   0=, if, then,            D1FF check
   begin, again,            E7FE check
   begin, 0<>, until,       D0FE check

end-code
.( PASS ) cr

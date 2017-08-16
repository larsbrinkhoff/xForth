require target/pic/asm.fth

hex

: fail? ( c a -- a' f ) cell - tuck @ <> ;
: .fail   cr ." FAIL: " source 5 - type cr ;
: ?fail   fail? if .fail abort then ;
: check   here begin depth 1- while ?fail repeat drop ;

variable j
: !jump   2800 here 2/ 3FF and +  j ! ;
: @jump   j @ ;

.( Assembler test: )
code assembler-test

   nop,                     0000 check
   return,                  0008 check
   retfie,                  0009 check
   sleep,                   0063 check

   0 call,                  2000 check
   2 goto,                  2801 check
   2 movlw,                 3002 check
   3 retlw,                 3403 check
   4 iorlw,                 3804 check
   5 andlw,                 3905 check
   6 xorlw,                 3A06 check
   7 sublw,                 3C07 check
   FF addlw,                3EFF check
   FFE call,                23FF check

   1 movwf,                 0081 check
   2 clrf,                  0182 check
   clrw,                    0100 check
   w 3 subwf,               0203 check
   f 4 decf,                0384 check
   f 5 iorwf,               0485 check
   w 6 andwf,               0506 check
   w 7 xorwf,               0607 check
   w 13 addwf,              0713 check
   f 63 addwf,              07E3 check
   w 8 movf,                0808 check
   f 9 movf,                0889 check
   w 10 comf,               0910 check
   w 11 incf,               0A11 check
   w 12 decfsz,             0B12 check
   w 13 rrf,                0C13 check
   w 14 rlf,                0D14 check
   w 15 swapf,              0E15 check
   w 16 incfsz,             0F16 check

   0 0 bcf,                 1000 check
   0 1 bcf,                 1001 check
   1 0 bcf,                 1080 check
   0 7F bsf,                147F check
   7 0 btfsc,               1B80 check
   7 7F btfss,              1FFF check

   ahead, then, !jump       @jump check
   0=, if, then, !jump      1D03 @jump check
   begin, !jump again,      @jump check
   begin, !jump 0=, until,  1D03 @jump check
end-code
.( PASS ) cr

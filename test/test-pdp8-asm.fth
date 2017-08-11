require target/pdp8/asm.fth

octal

: fail? ( c a -- a' f ) cell - tuck @ <> ;
: .fail   cr ." FAIL: " source 5 - type cr ;
: ?fail   fail? if .fail abort then ;
: check   here begin depth 1- while ?fail repeat drop ;

variable j
: cell/   cell / ;
: !jump   5200 here cell/ 177 and +  j ! ;
: @jump   j @ ;

.( Assembler test: )
code assembler-test

   ion,                     6001 check
   iof,                     6002 check
   nop,                     7000 check
   hlt,                     7402 check

   iac,                     7001 check
   ral,                     7004 check
   rtl,                     7006 check
   rar,                     7010 check
   rtr,                     7012 check
   cml,                     7020 check
   cma,                     7040 check
   cla,                     7200 check

   cla, iac, +,             7201 check
   cla, cma, +,             7240 check
   cla, cma, +, cll, +,     7340 check

   1 and,                   0001 check
   1 ) and,                 0401 check
   1234 and,                0234 check
   177 tad,                 1177 check
   177 ) isz,               2577 check
   1234 dca,                3234 check

   1 jms,                   4001 check
   177 jmp,                 5177 check

   176 here cell/ 177 and - cells allot
   42 # tad, page           1377 0042 check

   ahead, then, !jump       @jump check
   begin, !jump again,      @jump check
 \ 0=, if, then, !jump      1D03 @jump check
 \ begin, !jump 0=, until,  1D03 @jump check

end-code
.( PASS ) cr

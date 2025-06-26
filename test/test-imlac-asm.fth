require target/imlac/asm.fth

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

   hlt,                     000000 check
   don,                     003100 check
   iof,                     001161 check
   ion,                     001162 check
   ksf,                     002020 check
   1 ral,                   003001 check
   2 rar,                   003022 check
   3 sal,                   003043 check
   1 sar,                   003061 check

   nop,                     100000 check
   cla,                     100001 check
   cma,                     100002 check
   iac,                     100004 check
   cia,                     100006 check
   cml,                     100020 check

   cla, iac, +,             100005 check
   cla, cma, +,             100003 check
   cla, cma, +, cll, +,     100013 check

   1234 law,                005234 check
   1234 dac,                021234 check
   1 and,                   044001 check
   1 ) and,                 144001 check
   1234 and,                045234 check
   177 add,                 064177 check
   177 ) isz,               130177 check
   1234 dac,                021234 check
   1234 lac,                061234 check

   177 jmp,                 010177 check
   1234 ) jmp,              111234 check
   1 jms,                   034001 check

end-code
.( PASS ) cr

\ C backend.


only forth

hex 0 ram-dp ! decimal

also meta definitions also assembler

: ?first   over c@ 1 swap case  [char] - of ." minus" endof
   [char] < of ." less" endof  [char] > of ." greater" endof
   [char] 0 of ." zero" endof  [char] 1 of ." one" endof
   [char] 2 of ." two" endof   [char] 3 of ." three" endof
   [char] 4 of ." four" endof  [char] 5 of ." five" endof
   [char] 6 of ." six" endof   [char] 7 of ." seven" endof
   [char] 8 of ." eight" endof [char] 9 of ." nine" endof
   nip 0 swap endcase /string ;
: ?emit   2>r dup 2r> 1+ within if emit 0 then ;
: .mc    [char] 0 [char] 9 ?emit  [char] A [char] Z ?emit
   [char] a [char] z ?emit  case  [char] ? of ." question" endof
   [char] > of ." to" endof  [char] < of ." from" endof
   [char] ' of ." tick" endof  [char] = of ." equal" endof
   [char] . of ." dot" endof  [char] , of ." comma" endof
   [char] [ of ." lbracket" endof  [char] ] of ." rbracket" endof
   [char] + of ." plus" endof  [char] " of ." quote" endof
   [char] * of ." star" endof  [char] # of ." number" endof
   [char] / of ." slash" endof  [char] \ of ." backslash" endof
   [char] @ of ." fetch" endof  [char] ! of ." store" endof
   [char] : of ." colon" endof  [char] ; of ." semicolon" endof
   0 of endof  ." _" endcase ;
: .mangled   ?first bounds ?do i c@ .mc loop ;

: name,   dup , ", ;
: .header   ." static void " 2dup .mangled ." (void) {" cr ;
: header,   .header 2dup header, name, ;

: comp,   ."   " @+ .mangled ." ();" cr ;

: d.   base @ swap decimal . base ! ;
: t-num   ."   *--sp = " d. ." ;" cr ;

: prologue, ;
: end-target   ." int main (void) { cold(); return 0; }" cr ;

.( #include <stdint.h> ) cr
.( #include <stdlib.h> ) cr
.( typedef intptr_t cell_t; ) cr
.( static cell_t dstack[32], rstack[32]; ) cr
.( static char mem[4096]; ) cr
.( static cell_t *sp = &dstack[32]; ) cr
.( static cell_t *rp = &rstack[32]; ) cr
.( static void warm (void) char ) emit .( ; ) cr

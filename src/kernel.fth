include target/nucleus.fth

hex

: assert=   <> if panic then ;

variable var1
variable var2
42 constant const

: juggling   42 dup swap nip 42 assert= ;
: arithmetic   1 2 3 + + 2* 11 xor 2/ 0E assert= ;
: return   1 >r r@ r> assert= ;
: memory   42 var1 !  var1 c@ 42 assert=  var1 1+ c@ 0 assert=
           1 var2 c!  2 var2 1+ c!  var2 @ 0201 assert= ;
: ram   var2 var1 - 2 assert=  const 42 assert= ;
: test   juggling arithmetic return ram memory ;

also assembler then, \ Jump here from COLD.
: warm   test bye ;

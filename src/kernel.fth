include target/nucleus.fth

hex

: assert=   <> if panic then ;

variable var1
variable var2
42 constant const

: 2dup   over over ;

: juggling   42 dup swap nip 42 assert= ;
: arithmetic   1 2 3 + + 2* 11 xor 2/ 0E assert= ;
: return   1 >r r@ r> assert= ;
: ?and   and 0 assert= ;
: ?or   or 42 assert= ;
: memory   42 var1 !  var1 c@  var1 1+ c@  2dup ?and ?or
           1 var2 c!  2 var2 1+ c!  var2 @
	   dup 0102 = swap 0201 = or -1 assert= ;
: ram   var2 var1 - 2 assert=  const 42 assert= ;
: test   juggling arithmetic return ram memory ;

\ Jump here from COLD.
: warm   then test bye ;

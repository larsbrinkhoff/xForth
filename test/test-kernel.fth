hex

: assert=   <> if panic then ;

variable var1
variable var2
42 constant const

: 2dup   over over ;
: cell   0 cell+ ;

: juggling   42 dup swap nip 42 assert= ;
: arithmetic   1 2 3 + + 2* 11 xor 2/ 0E assert= ;
: negative   1 0< 0 assert=  -1 0< -1 assert= ;
: return   2 1 >r r@ r> assert= 2 assert= ;
: ?and   and 0 assert= ;
: ?or   or 42 assert= ;
: memory   42 var1 !  var1 c@  var1 1+ c@  2dup ?and ?or
           0 var2 !  1 var2 c!  2 var2 1+ c!  var2 @
	   dup 0102 = over 0201 = or swap 0001 = or -1 assert= ;
: abs   dup 0< if negate then ;
: ram   var2 var1 - abs cell assert=  const 42 assert= ;
: test   juggling arithmetic negative return ram memory ;

\ Jump here from COLD.
: warm   then test bye ;

code cold
   100 # r28 ldi, \ Set data stack pointer.
   r29 clr,
   128 # r16 ldi,
   48909 , \ 61 # r16 out, \ Set return stack pointer.
   ahead, \ Jump to WARM.
end-code

code +
   y+ r2 ld,
   r2 r30 add,
   y+ r2 ld,
   r2 r31 adc,
   ret,
end-code

code xor
   y+ r2 ld,
   r2 r30 eor,
   y+ r2 ld,
   r2 r31 eor,
   ret,
end-code

code 2*
   r30 lsl,
   r31 rol,
   ret,
end-code

code 2/
   r31 asr,
   r30 ror,
   ret,
end-code

code invert
   r30 com,
   r31 com,
   ret,
end-code

code @
   z+ r2 ld,
   z+ r3 ld,
   r2 r30 movw,
   ret,
end-code

code c@
   r30 r26 movw,
   x+ r30 ld,
   r31 clr,
   ret,
end-code

code drop
   y+ r30 ld,
   y+ r31 ld,
   ret,
end-code

code !
   r30 r26 movw,
   ] drop [ also assembler
   1 x+ )# r31 std,
   0 x+ )# r30 std,
   ] drop [ also assembler
   ret,
end-code

\ WRONG
code c!
   r30 r26 movw,
   ] drop [ also assembler
   r31 clr,
   x+ r30 st,
   ] drop [ also assembler
   ret,
end-code

code dup
   -y r31 st,
   -y r30 st,
   ret,
end-code

code ?dup
   0 # r30 adiw,
   0<>, if,
     ] dup [ also assembler
   then,
   ret,
end-code

code swap
   r30 r2 movw,
   ] drop [ also assembler
   -y r3 st,
   -y r2 st,
   ret,
end-code

code over
   ] dup [ also assembler
   2 y+ )# r30 ldd,
   3 y+ )# r31 ldd,
   ret,
end-code

code >r
   r31 push,
   r30 push,
   ] drop [ also assembler
   ret,
end-code

code r>
   ] dup [ also assembler
   r30 pop,
   r31 pop,
   ret,
end-code

code branch?
   r30 r31 or,
   y+ r30 ld,
   y+ r31 ld,
   ret,
end-code

: +!   dup >r @ + r> ! ;
: r@   r> r> dup >r swap >r ;

code halt
   break,
end-code

also assembler then, \ Jump here from COLD.
: warm   42 dup swap nip drop halt ;

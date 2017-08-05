code cold
   140 # r28 ldi, \ Set data stack pointer.
   r29 clr,
   158 # r16 ldi,
   48909 , \ 61 # r16 out, \ Set return stack pointer.
   ahead, \ Jump to WARM.
end-code

code +
   y+ r2 ld,
   r2 r26 add,
   y+ r2 ld,
   r2 r27 adc,
   ret,
end-code

code xor
   y+ r2 ld,
   r2 r26 eor,
   y+ r2 ld,
   r2 r27 eor,
   ret,
end-code

code 2*
   r26 lsl,
   r27 rol,
   ret,
end-code

code 2/
   r27 asr,
   r26 ror,
   ret,
end-code

code invert
   r26 com,
   r27 com,
   ret,
end-code

code @
   r26 r30 movw,
   z+ r26 ld,
   z+ r27 ld,
   ret,
end-code

code c@
   x r26 ld,
   r27 clr,
   ret,
end-code

code drop
   y+ r26 ld,
   y+ r27 ld,
   ret,
end-code

code !
   r26 r30 movw,
   ] drop [ also assembler
   z+ r26 st,
   z+ r27 st,
   ] drop [ also assembler
   ret,
end-code

code c!
   r26 r30 movw,
   ] drop [ also assembler
   r27 clr,
   z+ r26 st,
   z+ r27 st,
   ] drop [ also assembler
   ret,
end-code

code dup
   -y r27 st,
   -y r26 st,
   ret,
end-code

code ?dup
   0 # r26 adiw,
   0<>, if,
     ] dup [ also assembler
   then,
   ret,
end-code

code swap
   r26 r2 movw,
   ] drop [ also assembler
   -y r3 st,
   -y r2 st,
   ret,
end-code

code over
   ] dup [ also assembler
   2 y+ )# r26 ldd,
   3 y+ )# r27 ldd,
   ret,
end-code

code >r
   r31 pop,
   r30 pop,
   r26 push,
   r27 push,
   ] drop [ also assembler
   z ijmp,
end-code

code r>
   r31 pop,
   r30 pop,
   ] dup [ also assembler
   r27 pop,
   r26 pop,
   z ijmp,
end-code

code branch?
   r26 r27 or,
   y+ r26 ld,
   y+ r27 ld,
   ret,
end-code

: +!   dup >r @ + r> ! ;
: r@   r> r> dup >r swap >r ;
: negate   invert 1+ ;
: -   negate + ;
: 0=   if 0 else -1 then ;
: 0<>   0= 0= ;
: =   - 0= ;
: <>   - 0<> ;

code panic
   255 dup c, c, \ Illegal instruction.
   break,
end-code

code bye
   break,
end-code

: assert=   <> if panic then ;

: juggling   42 dup swap nip 42 assert= ;
: arithmetic   1 2 + 3 + 6 assert= ;
: return   1 >r 1 r> assert= ;
: test   juggling arithmetic return ;

also assembler then, \ Jump here from COLD.
: warm   test bye ;

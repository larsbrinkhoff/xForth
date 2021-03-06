code iv,
   ahead, nop, \ Interrupt vectors. atmeba328p each IV = 2 instructions, 26 interrupt vectors => 52 cells (ahead, + nop, = reset; + 25IV)
   nop, nop, nop, nop, nop, nop, nop, nop,
   nop, nop, nop, nop, nop, nop, nop, nop,
   nop, nop, nop, nop, nop, nop, nop, nop,
   nop, nop,
   nop, nop, nop, nop, nop, nop, nop, nop,
   nop, nop, nop, nop, nop, nop, nop, nop,
   nop, nop, nop, nop, nop, nop, nop, nop,
end-code

code cold,
   then,
(   140 # r28 ldi, \ Set data stack pointer. Problem s pretekanim!!!! zmenit pocatky OBOUT stacků
   r29 clr,
   158 # r16 ldi,
   61 r16 out, \ Set return stack pointer. )

   255 # r28 ldi, \ Set data stack pointer to 3/4 of ram
   6 # r29 ldi,

   255 # r16 ldi,  \ Set return stack pointer to ram end
   61 r16 out,
   8 # r16 ldi,
   62 r16 out,

   ahead, \ Jump to WARM.
end-code

code invert
   r26 com,
   r27 com,
   ret,
end-code

: negate   invert 1+ ;
: -   negate [  \ Fall through.

code +
   y+ r2 ld,
   r2 r26 add,
   y+ r2 ld,
   r2 r27 adc,
   ret,
end-code

code and
   y+ r2 ld,
   r2 r26 and,
   y+ r2 ld,
   r2 r27 and,
   ret,
end-code

code or
   y+ r2 ld,
   r2 r26 or,
   y+ r2 ld,
   r2 r27 or,
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

code @
   r26 r30 movw,
   z+ r26 ld,
   z r27 ld,
   ret,
end-code

code c@
   x r26 ld,
   r27 clr,
   ret,
end-code

code dup
   -y r27 st,
   -y r26 st,
   ret,
end-code

code branch?
   r26 r27 or,
   \ Fall through.
end-code

code drop
   y+ r26 ld,
   y+ r27 ld,
   ret,
end-code

code >r
   r31 pop,
   r30 pop,
   r26 push,
   r27 push,
   ] drop [ also assembler
   ijmp,
end-code

code r>
   r31 pop,
   r30 pop,
   ] dup [ also assembler
   r27 pop,
   r26 pop,
   ijmp,
end-code

: +!   dup >r @ + r> [  \ Fall through.

code !
   r26 r30 movw,
   ] drop [ also assembler
   z+ r26 st,
   z r27 st,
   ' drop rjmp,
end-code

code c!
   r26 r30 movw,
   ] drop [ also assembler
   z r26 st,
   ' drop rjmp,
end-code

code ?dup
   0 # r26 adiw,
   0<>, if,
     ' dup rjmp,
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
   2 y )# r26 ldd,
   3 y )# r27 ldd,
   ret,
end-code

code 0<
   0 # r26 adiw,
   0<, if,
     255 # r26 ldi,
     255 # r27 ldi,
     ret,
   else,
     0 # r26 ldi,
     0 # r27 ldi,
     ret,
  then,
end-code

code swr
   -y r27 st,
   63 r27 in,
   -y r27 st,
   -y r26 st,
   -y r3 st,
   -y r2 st,
   -y r31 st,
   -y r30 st,
   ret,
end-code

code rwr
   y+ r30 ld,
   y+ r31 ld,
   y+ r2 ld,
   y+ r3 ld,
   y+ r26 ld,
   y+ r27 ld,
   63 r27 out,
   y+ r27 ld,
   ret,
end-code




: r@   r> r> dup >r swap >r ;
: =   - [  \ Fall through.
: 0=   if 0 else -1 then ;
: <>   - [  \ Fall through.
: 0<>   0= 0= ;

code bye
   break,
end-code

: panic   [ 255 dup c, c, ] bye ; \ FFFF is an undefined instruction.

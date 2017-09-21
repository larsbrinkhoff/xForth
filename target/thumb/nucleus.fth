\ Cortex-M0 memory map:
\ 0x00000000 code
\          0 initial SP
\          4 reset vector (lsb must be 1)
\ 0x20000000 data
\ 0x40000000 peripheral
\ 0xE0000000 peripheral
\   E000E000 system control

0 org
hex

20000800 , \ Initial stack pointer.
00000101 , \ Reset vector

100 here - allot

code cold
   sp r7 movh,
   80 # r7 subi,
   80 # r7 subi,
   ahead,
end-code

code bye
   0 # bkpt,
end-code

code panic
   FF # bkpt,
end-code

code dup
   ] dup [ also assembler
   lr bx,
end-code

code drop
   ] drop [ also assembler
   lr bx,
end-code

code swap
   r7 ) r5 ldr,
   r7 ) r6 str,
   r5 r6 mov,
   lr bx,
end-code

code over
   ] dup [ also assembler
   4 r7 )# r6 ldr,
   lr bx,
end-code

code +
   r7 ) r5 ldr,
   r6 r5 r6 add,
   4 # r7 addi,
   lr bx,
end-code

code or
   r7 ) r5 ldr,
   r5 r6 orr,
   4 # r7 addi,
   lr bx,
end-code

code xor
   r7 ) r5 ldr,
   r5 r6 eor,
   4 # r7 addi,
   lr bx,
end-code

code and
   r7 ) r5 ldr,
   r5 r6 and,
   4 # r7 addi,
   lr bx,
end-code

code >r
   {r6} push,
   ' drop b,
end-code

code r>
   ] dup [ also assembler
   {r6} pop,
   lr bx,
end-code

code r@
   ] dup [ also assembler
   0 sp) r6 ldr,
   lr bx,
end-code

code !
   r7 ) r5 ldr,
   r6 ) r5 str,
   \ Drop through.
end-code

code 2drop
   4 r7 )# r6 ldr,
   8 # r7 addi,
   lr bx,
end-code

code c!
   r7 ) r5 ldr,
   r6 ) r5 strb,
   ' 2drop b,
end-code

code branch?
   r6 r5 mov,
   ] drop [ also assembler
   r5 r5 tst,
   lr bx,
end-code

(* code 0=
   0 # r5 movi,
   r6 tst,
   0<> if,
     1 # r5 subi,
   then,
   r5 r6 mov,
   lr bx,
end-code *)

: +!   dup >r @ + r> ! ;
: 0=   if 0 else -1 then ;
: 0<>   0= 0= ;
: -   negate + ;
: =   - 0= ;
: <>   - 0<> ;

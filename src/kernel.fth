code +
   y+ r2 ld,
   r2 r0 add,
   y+ r2 ld,
   r2 r1 adc,
   ret,
end-code

code 2*
   r0 lsl,
   r1 rol,
   ret,
end-code

code invert
   r0 com,
   r1 com,
   ret,
end-code

code @
   \ r0 z movw,
   z+ r0 ld,
   z+ r1 ld,
   ret,
end-code

code drop
   y+ r0 ld,
   y+ r1 ld,
   ret,
end-code

code !
   \ r0 z movw,
   ] drop [ also assembler
   1 z+ )# r1 std,
   0 z+ )# r0 std,
   ] drop [ also assembler
   ret,
end-code

code dup
   -y r1 st,
   -y r0 st,
   ret,
end-code

code over
   ] dup [ also assembler
   2 y+ )# r0 ldd,
   3 y+ )# r1 ldd,
   ret,
end-code

code >r
   r1 push,
   r0 push,
   ] drop [ also assembler
   ret,
end-code

code r>
   ] dup [ also assembler
   r0 pop,
   r1 pop,
   ret,
end-code

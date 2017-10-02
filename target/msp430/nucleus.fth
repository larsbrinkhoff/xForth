hex
0F000 org

code cold
   0400 # sp mov, \ Set return stack pointer.
   0300 # r4 mov, \ Set data stack pointer.
   ahead, \ Jump to WARM.
end-code

: drop   drop ;

code !
   r4 )+ 0 r5 )# mov,
   ' drop jmp,
end-code

code c!
   r4 )+ 0 r5 )# .b mov,
   1# r4 add,
   ' drop jmp,
end-code

code dup
   2# r4 sub,
   r5 0 r4 )# mov,
   ret,
end-code

code ?dup
   r5 tst,
   0<>, if,
     ' dup jmp,
   then,
   ret,
end-code

code swap
   r4 ) r6 mov,
   r5 0 r4 )# mov,
   r6 r5 mov,
   ret,
end-code

code over
   ] dup [ also assembler
   2 r4 )# r5 mov,
   ret,
end-code

code r>
   r6 pop,
   ] dup [ also assembler
   r5 pop,
   r6 br,
end-code

code 0=
   r5 tst,
label zero?
   0=, if,
     -1# r5 mov,
     ret,
   then,
   0# r5 mov,
   ret,
end-code

code =
   r4 )+ r5 sub,
   zero? jmp,
end-code

code 0<
   r5 tst,
   0<, if,
     -1# r5 mov,
     ret,
   then,
   0# r5 mov,
   ret,
end-code

code +!
   r4 )+ 0 r5 )# add,
   ' drop jmp,
end-code

code r@
   ] dup [ also assembler
   2 sp )# r5 mov,
   ret,
end-code

: 0<>   0= 0= ;
: -   negate + ;
: <>   - 0<> ;

code bye
   0# 0 & mov,
end-code

code panic
   1# 0 & mov,
end-code

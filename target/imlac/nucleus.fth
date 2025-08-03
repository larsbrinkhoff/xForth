octal

100 cells here - allot

code cold
   -1 cells allot
   7000 # lac,
   sp dac,
   6400 # lac,
   rp dac,
   +# jmp, >mark
end-code

code bye
   hlt,
end-code

code panic
   hlt,
end-code

code push
   sp xam,
   temp2 dac,
   sp lac,
   temp2 ) dac,
   sta,
   temp2 add,
   sp dac,
   exit,
end-code

code dup
   temp1 dac,
   push,
   temp1 lac,
   exit,
end-code

code swap
   temp1 dac,
   sp lac,
   iac,
   temp2 dac,
   temp1 lac,
   temp2 ) xam,
   exit,
end-code

code over
   push,
   2 # add,
   temp1 dac,
   temp1 ) lac,
   exit,
end-code

code (>r)
   rp xam,
   temp1 dac,
   rp lac,
   temp1 ) dac,
   sta,
   temp1 add,
   rp dac,
   sp ) lac,
   exit,
end-code

code (r>)
   push,
   rp ) lac,
   exit,
end-code

code @
   temp1 dac,
   temp1 ) lac,
   exit,
end-code

code !
   temp1 dac,
   sp ) lac,
   temp1 ) dac,
   sp ) lac,
   exit,
end-code

code -
   sp ) sub,
   cia,
   exit,
end-code

code +!
   temp1 dac,
   sp ) lac,
   temp1 ) add,
   sp ) lac,
   exit,
end-code

: c! ! ;
: c@ @ ;

code 0branch
   asz,
    ' 0branch isz,
   sp ) lac,
   exit,
end-code

code 0
   push,
   cla,
   exit,
end-code

code 1
   push,
   coa,
   exit,
end-code

code 2*
   cll,
   1 ral,
   exit,
end-code

code -1
   push,
   sta,
   exit,
end-code

code 0<
   asm,
    ahead,
   sta,
   exit,
   then,
   cla,
   exit,
end-code

code 0<>
    asz,
     sta,
    exit,
end-code

: 0=   0<> invert ;

code <>
   sp ) sub,
   ' 0<> jms,
   exit,
end-code

: =   <> invert ;

: sp0   7000 10 ! ;
: rp0   6400 11 ! ;

code execute
   temp1 dac,
   sp ) lac,
   temp1 ) jms,
   exit,
end-code

code emit
     begin,
     tsf,
      again,
     tpc,
     sp ) lac,
     exit,
end-code

code key
     begin,
     rsf,
      again,
     rrb,
     sp ) lac,
     exit,
end-code

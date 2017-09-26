octal
0 org

code cold
   cla,
   7000 # tad,
   sp dca,
   6400 # tad,
   rp dca,
   +# jmp, >mark
end-code

\ The stack pointers use auto incrementation.
10 cells here - allot
0 ,
0 ,

20 cells here - allot

code bye
   hlt,
end-code

code panic
   hlt,
end-code

code push
   temp1 dca,
   sp tad,
   temp2 dca,
   temp1 tad,
   temp2 ) dca,
   cma,
   temp2 tad,
   sp dca,
   exit,
end-code

code dup
   ' push jms,
   temp1 tad,
   exit,
end-code

code drop
   cla,
   sp ) tad,
   exit,
end-code

code swap
   temp1 dca,
   cla, iac, +,
   sp tad,
   temp2 dca,
   temp2 ) tad,
   temp3 dca,
   temp1 tad,
   temp2 ) dca,
   temp3 tad,
   exit,
end-code

code over
   ' push jms,
   cla, cll, +, cml, +, rtl, +,
   sp tad,
   temp1 dca,
   temp1 ) tad,
   exit,
end-code

code xor
   temp1 dca,
   sp ) tad,
   temp2 dca,
   temp1 tad,
   temp2 and,
   cma, iac,
   cll, ral,
   temp1 tad,
   temp2 tad,
   exit,
end-code

code or
   cma,
   temp1 dca,
   sp ) tad,
   cma,
   temp1 and,
   cma,
   exit,
end-code

code 2/
   cll, cml, +,
   sma,
    cml,
   rar,
   exit,
end-code

code >r
   temp1 dca,
   rp tad,
   temp2 dca,
   temp1 tad,
   temp2 ) dca,
   cma,
   temp2 tad,
   rp dca,
   sp ) tad,
   exit,
end-code

code r>
   ' push jms,
   rp ) tad,
   exit,
end-code

code r@
   ' push jms,
   iac,
   rp tad,
   temp1 dca,
   temp1 ) tad,
   exit,
end-code
   
code !
   temp1 dca,
   sp ) tad,
   temp1 ) dca,
   sp ) tad,
   exit,
end-code

code @
   temp1 dca,
   temp1 ) tad,
   exit,
end-code

: c! ! ;
: c@ @ ;

code branch?
   cll,
   sza,
    cml,
   cla,
   sp ) tad,
   exit,
end-code

code 0
   ' push jms,
   \ AC is already cleared.
   exit,
end-code

code 1
   ' push jms,
   cla, iac, +,
   exit,
end-code

code 2
   ' push jms,
   cla, cll, +, cml, +, rtl, +,
   exit,
end-code

code -1
   ' push jms,
   cla, cma, +,
   exit,
end-code

code -2
   ' push jms,
   cla, cma, +, cll, +, ral, +,
   exit,
end-code

code -3
   ' push jms,
   cla, cma, +, cll, +, rtl, +,
   exit,
end-code

code 0<
   0<, if,
     cla, cma, +,
   else,
     cla,
   then,
   exit,
end-code

: +!   dup >r @ + r> ! ;
: -   negate + ;
: 0=   if 0 else -1 then ;
: 1-   1 - ;
: 0<>   0= 0= ;
: =   - 0= ;
: <>   - 0<> ;

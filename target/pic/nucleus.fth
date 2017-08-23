hex
0 org

code cold
   ahead,
end-code

code dup
   -2 movlw,
   f s addwf,

   w s movf,
   fsr movwf,
   w t movf,
   indf movwf,

   f fsr incf,
   w t 1+ movf,
   indf movwf,

   return,
end-code

code drop
   w s movf,
   fsr movwf,
   w indf movf,
   t movwf,

   f fsr incf,
   w indf movf,
   t 1+ movwf,
   
   2 movlw,
   f s addwf,

   return,
end-code

code nip
   2 movlw,
   f s addwf,
   return,
end-code

code +
   w s movf,
   fsr movwf,
   w indf movf,
   f t addwf,
   0 status btfsc,
    f t 1+ incf,
   f fsr incf,
   w indf movf,
   f t 1+ addwf,   
   return,
end-code

code xor
   w s movf,
   fsr movwf,
   w indf movf,
   f t xorwf,
   f fsr incf,
   w indf movf,
   f t 1+ xorwf,
   return,
end-code

code 2*
   0 status bcf,
   f t rlf,
   f t 1+ rlf,
   return,
end-code

code 2/
   0 status bcf,
   7 t 1+ btfsc,
    0 status bsf,
   f t 1+ rrf,
   f t rrf,
   return,
end-code

code invert
   f t comf,
   f t 1+ comf,
   return,
end-code

code @
   w t movf,
   fsr movwf,
   w indf movf,
   t movwf,
   f fsr incf,
   w indf movf,
   t 1+ movwf,
   return,
end-code

code c@
   w t movf,
   fsr movwf,
   w indf movf,
   t movwf,
   t 1+ clrf,
   return,
end-code

code !
   w s movf,
   fsr movwf,
   w indf movf,
   x movwf,
   f fsr incf,
   w indf movf,
   x 1+ movwf,

   w t movf,
   fsr movwf,
   w x movf,
   indf movwf,

   f fsr incf,
   w x 1+ movf,
   indf movwf,

   2 movlw,
   f s addwf,
   ' drop goto,
end-code

code c!
   w s movf,
   fsr movwf,
   w indf movf,
   x movwf,

   w t movf,
   fsr movwf,
   w x movf,
   indf movwf,

   2 movlw,
   f s addwf,
   ' drop goto,
end-code

code swap
   w t movf,
   x movwf,
   w t 1+ movf,
   x 1+ movwf,
   
   w s movf,
   fsr movwf,
   w indf movf,
   t movwf,
   f fsr incf,
   w indf movf,
   t 1+ movwf,

   w x 1+ movf,
   indf movwf,
   f fsr decf,
   w x movf,
   indf movwf,

   return,
end-code

code over
   ] dup [ also assembler

   w s movf,
   2 addlw,
   fsr movwf,
   
   w indf movf,
   t movwf,
   f fsr incf,
   w indf movf,
   t 1+ movwf,

   return,
end-code

variable rp

code branch?
   w x movf,
   w x 1+ iorwf,
   return,
end-code

: 1+   1 + ;
: ?dup   dup if dup then ;
: negate   invert 1+ ;
: -   negate + ;
: >r   rp @ 2 - dup rp ! ! ;
: r>   rp @ dup @ swap 2 + rp ! ;
: r@   r> r> dup >r swap >r ;
: +!   dup >r @ + r> ! ;
: 0=   if 0 else -1 then ;
: 0<>   0= 0= ;
: =   - 0= ;
: <>   - 0<> ;

: cell+   2 + ;
: 1-   1 - ;

code bye
end-code

code panic
end-code

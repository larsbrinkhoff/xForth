hex
0 org

code cold
   5 status bsf,
   0F movlw,
   option_reg movwf,
   5 status bcf,
   clrwdt,

   50 movlw,
   s movwf,

   40 movlw,
   rp movwf,

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

code nip
   2 movlw,
   f s addwf,
   return,
end-code

code invert
   f t comf,
   f t 1+ comf,
   return,
end-code

: negate   invert [  \ Fall through.
: 1+   1 [  \ Fall through.

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
   ' nip goto,
end-code

code and
   w s movf,
   fsr movwf,
   w indf movf,
   f t andwf,
   f fsr incf,
   w indf movf,
   f t 1+ andwf,
   ' nip goto,
end-code

code or
   w s movf,
   fsr movwf,
   w indf movf,
   f t iorwf,
   f fsr incf,
   w indf movf,
   f t 1+ iorwf,
   ' nip goto,
end-code

code xor
   w s movf,
   fsr movwf,
   w indf movf,
   f t xorwf,
   f fsr incf,
   w indf movf,
   f t 1+ xorwf,
   ' nip goto,
end-code

: 2*   dup + ;

code 2/
   0 status bcf,
   7 t 1+ btfsc,
    0 status bsf,
   f t 1+ rrf,
   f t rrf,
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
   ] @ [ also assembler
   t 1+ clrf,
   return,
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

: r>   rp @ dup @ swap 2 + rp [  \ Fall through.

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
   \ Fall through.
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

code branch?
   w t movf,
   w t 1+ iorwf,
   x movwf,
   ' drop call,
   f x movf,
   return,
end-code

code 0<
   0 movlw,
   7 t 1+ btfsc,
    FF movlw,
   t movwf,
   t 1+ movwf,
   return,
end-code

: ?dup   dup if dup then ;
: 1-   1 [  \ Fall through.
: -   negate + ;
: >r   rp @ 2 - dup rp ! ! ;
: r@   rp @ @ ;
: +!   dup >r @ + r> ! ;
: =   - [  \ Fall through.
: 0=   if 0 else -1 then ;
: 0<>   0= 0= ;
: <>   invert 1+ + if -1 else 0 then ;

: cell+   2 + ;

code bye
   60 movwf,
end-code

code panic
   63 movwf,
end-code

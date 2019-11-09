hex

\ This is for an ATmega328P running at 16 MHz.  Other parts may need
\ other register addresses.

code setup-uart
   0 # r16 ldi,
   C5 r16 sts,
   67 # r16 ldi,
   C4 r16 sts, \ UBRR0, 9600
   18 # r16 ldi,
   C1 r16 sts, \ UCSR0B, Rx and tx enabled.
   6 # r16 ldi,
   C2 r16 sts, \ USCR0C, 8N1
   ret,
end-code

code emit
   C0 r16 lds,
   5 # r16 sbrs, \ UCSR0A, data register empty.
   ' emit rjmp,
   C6 r26 sts, \ UDR0
   ' drop rjmp,
end-code

code key
   ] dup [ also assembler
label key1
   C0 r16 lds,
   7 # r16 sbrs, \ UCSR0A, receive complete.
   key1 rjmp,
   C6 r26 lds, \ UDR0
   r27 clr,
   ret,
end-code

decimal

include target/avr/uart.fth

hex

code set-output
   FF # r16 ldi,
   04 r16 out, \ DDRB
   FF # r16 ldi,
   07 r16 out, \ DDRC
   ret,
end-code

code !portb
   05 r26 out,
   ' drop rjmp,
end-code

code !portc
   08 r26 out,
   ' drop rjmp,
end-code

: more ( x -- x' ) dup 40 = if drop 1 then ;
: cycle ( x -- x' ) dup dup + swap !portc more ;

variable n
variable x

: setup  setup-uart set-output  200 n !  100 x ! ;
: delay   begin 1- dup 0= until drop ;
: led-on   01 !portb 300 delay ;
: led-off   0 !portb 300 delay ;
\ Jump here from COLD.
: warm   then setup 01 begin led-off led-on 41 emit key emit cycle again ;

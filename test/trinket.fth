include target/nucleus.fth

hex

code set-output
   FF # r16 ldi,
   17 r16 out,
   ret,
end-code

code !portb
   18 r26 out,
   ' drop rjmp,
end-code

variable n
variable x

code 0<
   0 # r26 adiw,
   0<, if,
     FF # r26 ldi,
     FF # r27 ldi,
     ret,
   else,
     0 # r26 ldi,
     0 # r27 ldi,
     ret,
  then,
end-code

: setup  set-output  F000 n !  1000 x ! ;
: delay   begin 1- dup 0= until drop ;
: led-on   2 !portb x @ delay ;
: led-off   0 !portb n @ x @ - delay ;
\ Jump here from COLD.
: warm   then setup begin led-off led-on again ;

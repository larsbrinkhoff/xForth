include target/nucleus.fth

hex
00C constant porta
00E constant portc

code set-output
   1 movlb,
   00 movlw,
   00C movwf, \ TRISA
   00E movwf, \ TRISC
   0 movlb,
   return,
end-code

: !porta   porta c! ;

variable n
variable x

: setup  set-output  600 n !  200 x ! ;
: delay   begin 1- dup 0= until drop ;
: led-on   FF !porta  x @ delay ;
: led-off   00 !porta  n @ x @ - delay ;
\ Jump here from COLD.
: warm   then setup begin led-off led-on again ;

5005 constant pb_odr
5007 constant pb_ddr
5008 constant pb_cr1
5009 constant pb_cr2

: set-output   20 pb_ddr c!  20 pb_cr1 c! ;
: !portb   pb_odr c! ;

variable n
variable x

: setup  set-output  1000 n !  400 x ! ;
: delay   begin 1- dup 0= until drop ;
: led-on   0 !portb x @ delay ;
: led-off   FF !portb n @ x @ - delay ;
\ Jump here from COLD.
: warm   then setup begin led-off led-on again ;

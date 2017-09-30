include target/nucleus.fth

hex
0120 constant wdtctl
5A00 constant wdtpw
0080 constant wdthold
0022 constant p1dir
0021 constant p1out

: set-output   wdtpw wdthold + wdtctl !  FF p1dir c! ;
: !port1   p1out c! ;

variable n
variable x

: setup  set-output  6000 n !  2000 x ! ;
: delay   begin 1- dup 0= until drop ;
: led-on   FF !port1  x @ delay ;
: led-off   0 !port1  n @ x @ - delay ;
\ Jump here from COLD.
: warm   then setup begin led-off led-on again ;

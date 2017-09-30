only forth definitions
08000000 constant flash-start \ STM32L011
also meta target

include target/nucleus.fth

4002102C constant rcc_iopenr
50000400 constant gpiob_moder
50000414 constant gpiob_odr

: set-output   2 rcc_iopenr !  55555555 gpiob_moder ! ;
: !portb   gpiob_odr ! ;

variable n
variable x

: setup  set-output  10000 n !  4000 x ! ;
: delay   begin 1- dup 0= until drop ;
: led-on   0 !portb x @ delay ;
: led-off   0000FFFF !portb n @ x @ - delay ;
\ Jump here from COLD.
: warm   then setup begin led-off led-on again ;

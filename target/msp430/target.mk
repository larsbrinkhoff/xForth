START = 0xF000
OPTS = -msp430 -break_io 0x0000 -set_pc $(START) -bin -address $(START)

test-image: image
	naken_util $(OPTS) -run image > $@

upload: image.hex
	sudo mspdebug rf2500 "prog $<"

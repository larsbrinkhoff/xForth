START = 0x1000
OPTS = -6502 -break_io 0xF000 -set_pc $(START) -bin -address $(START)

test-image: image
	naken_util $(OPTS) -run image > $@

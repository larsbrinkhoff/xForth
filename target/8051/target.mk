START = 0

test-image: image.hex
	s51 -J $< < target/8051/test.ucsim > $@
	! grep "Stop at 0x000023" $@
	grep "Stop at 0x00001b" $@

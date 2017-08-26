START=0x8000

test-image: image.hex
	sstm8 -J -tS103 -C target/stm8/test.ucsim > $@
	! grep "Invalid instruction 0x0005" $@
	grep "Invalid instruction 0x008b" $@

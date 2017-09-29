START=0x8000

test-image: image.hex
	sstm8 -J -tS103 -C $(TDIR)/test.ucsim > $@
	! grep "Invalid instruction 0x0005" $@
	grep "Invalid instruction 0x008b" $@

upload: image.hex
	sudo stm8flash -c stlinkv2 -p stm8s103f3 -w $<


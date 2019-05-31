START=0x8000

test-image: image.hex
	sstm8 -J -tS103 -C $(TDIR)/test.ucsim > $@
	! grep "05             UNKNOWN/INVALID" $@
	grep "8b             break" $@

upload: image.hex
	sudo stm8flash -c stlinkv2 -p stm8s103f3 -w $<


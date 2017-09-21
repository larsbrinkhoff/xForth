test-image: image
	thumbulator -m 0 -d $< > $@ 2>&1
	! grep "bkpt 0xFF" $@
	grep "bkpt 0x00" $@

START=0

test-image: image.hex
	gpsim -c $(TDIR)/test.stc > $@
	! grep INVREG_63 $@
	grep INVREG_60 $@

test-image: image.hex
	gpsim -c target/pic/test.stc > $@
	! grep INVREG_63 $@
	grep INVREG_60 $@

image.hex: image
	objcopy -I binary -O ihex $< $@

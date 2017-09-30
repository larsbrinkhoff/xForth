# This is for STM32L0x1 devices.
START=0x08000000

test-image: image
	thumbulator -m 0 -d $< > $@ 2>&1
	! grep "bkpt 0xFF" $@
	grep "bkpt 0x00" $@

upload: image
	sudo st-flash write $< $(START)

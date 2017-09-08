test-image: image
	simulavr -D -d at90s2313 $< > $@ 2>&1
	! grep "Unknown opcode" $@
	grep "BREAK POINT" $@

upload: image
	sudo avrdude -C $(TDIR)/avrdude.conf -c usbtiny -p attiny85 -U flash:w:image:r -P usb

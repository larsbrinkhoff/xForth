image.simh: image
	$(TDIR)/convert.sh < $< > $@
	echo set crt disabled >> $@
	echo run 100 >> $@
	echo quit >> $@

test-image: image.simh
	imlac $< > $@
	! grep "HALT instruction, PC: 00111" $@
	grep "HALT instruction, PC: 00107" $@

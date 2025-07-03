image.simh: image
	$(TDIR)/convert.sh < $< > $@
	echo set crt disabled >> $@
	echo set tty type=file >> $@
	echo set debug stdout >> $@
	echo set tty debug >> $@
	echo attach tty OUTPUT >> $@
	echo run 100 >> $@
	echo quit >> $@

test-image: image.simh
	imlac $< > $@
	! grep "HALT instruction, PC: 00110" $@
	grep "HALT instruction, PC: 00106" $@

kernel.simh: kernel
	$(TDIR)/convert.sh < $< > $@
	echo "set crt disabled" >> $@
	echo "attach -u tty 12345" >> $@
	echo "dep pc 100" >> $@

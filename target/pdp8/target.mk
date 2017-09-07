image.simh: image
	$(TDIR)/convert.sh < $< > $@

test-image: image.simh
	printf 'run 0\nquit\n' | pdp8 $< > $@
	! grep "HALT instruction, PC: 00024" $@
	grep "HALT instruction, PC: 00022" $@

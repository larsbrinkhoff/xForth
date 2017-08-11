test-image: image
	simulavr -D -d at90s2313 $< > $@ 2>&1
	! grep "Unknown opcode" $@
	grep "BREAK POINT" $@

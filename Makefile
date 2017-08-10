all: check

check: test-avr-asm test-msp430-asm test-image

image: src/compiler.fth src/kernel.fth
	echo include $< | forth

test-image: image
	simulavr -D -d at90s2313 $< > $@ 2>&1
	! grep "Unknown opcode" $@
	grep "BREAK POINT" $@

test-%-asm: test/test-%-asm.fth target/%/asm.fth
	echo include $< | forth > $@
	grep "Assembler test: PASS" $@

clean:
	rm -f test-* image

all: check

check: test-avr-asm test-image

image: src/compiler.fth src/kernel.fth
	echo include $< | forth

test-image: image
	simulavr -D -d at90s2313 $< > $@ 2> /dev/null
	grep "BREAK POINT: PC = 0x00000003" $@

test-%-asm: test/test-%-asm.fth target/%/asm.fth
	echo include $< | forth > $@
	grep "Assembler test: PASS" $@

clean:
	rm -f test-* image

all: check

check: test-avr-asm

test-%-asm: test/test-%-asm.fth target/%/asm.fth
	echo include $< | forth > $@
	grep "Assembler test: PASS" $@

clean:
	rm -f test-*-asm

-include conf.mk
include target/$(TARGET)/target.mk

T = target/asm.fth target/x1.fth target/x2.fth target/nucleus.fth
STAMP = $(TARGET)-stamp

all: check

$(STAMP): $(wildcard conf.mk)
	rm -f *-stamp
	touch $@

check: test-$(TARGET)-asm test-image

image: src/compiler.fth src/kernel.fth $(T)
	echo include $< | forth

target/%.fth: target/$(TARGET)/%.fth $(STAMP)
	cp $< $@

test-%-asm: test/test-%-asm.fth target/%/asm.fth
	echo include $< | forth > $@
	grep "Assembler test: PASS" $@

clean:
	rm -f test-* image target/*.fth *-stamp

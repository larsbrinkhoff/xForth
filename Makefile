-include conf.mk

T = target/params.fth target/asm.fth target/x1.fth target/x2.fth \
    target/x3.fth target/nucleus.fth
K = lib/kernel.fth lib/dict.fth lib/input.fth lib/number.fth \
    lib/interpreter.fth lib/compiler.fth lib/core.fth
STAMP = $(TARGET)-stamp
TDIR = target/$(TARGET)

all: check

$(STAMP): $(wildcard conf.mk)
	rm -f *-stamp
	touch $@

check: test-$(TARGET)-asm test-image

image: test/test-kernel.fth src/compile src/compiler.fth $(T)
	./src/compile $< image

image.hex: image
	objcopy -I binary -O ihex --change-section-address .data=$(START) $< $@

kernel: $(K) image
	mv image image.tmp
	./src/compile $< $@
	mv image.tmp image

target/%.fth: $(TDIR)/%.fth $(STAMP)
	cp $< $@

test-%-asm: test/test-%-asm.fth target/%/asm.fth
	echo include $< | forth > $@
	grep "Assembler test: PASS" $@

.gdbinit: $(TDIR)/gdbinit
	cp $< $@

clean:
	rm -f test-* image target/*.fth *-stamp

include $(TDIR)/target.mk

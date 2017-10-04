-include conf.mk

T = target/params.fth target/asm.fth target/x1.fth target/x2.fth \
    target/nucleus.fth
STAMP = $(TARGET)-stamp
TDIR = target/$(TARGET)

all: check

$(STAMP): $(wildcard conf.mk)
	rm -f *-stamp
	touch $@

check: test-$(TARGET)-asm test-image

image image.log: src/compiler.fth src/kernel.fth $(T)
	echo include $< | forth > image.log

image.hex: image
	objcopy -I binary -O ihex --change-section-address .data=$(START) $< $@

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

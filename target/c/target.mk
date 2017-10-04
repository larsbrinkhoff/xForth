$(TDIR)/params.fth: params
	./$< > $@

params: $(TDIR)/params.c
	$(CC) $< -o $@

image.c: image.log
	tail -n+3 $< | head -n-1 > $@

image.exe: image.c
	$(CC) $< -o $@

test-image: image.exe
	./$<
	touch $@

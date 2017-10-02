START=0

test-image: image.hex
	gpsim -c $(TDIR)/test.stc > $@
	! grep INVREG_63 $@
	grep INVREG_60 $@

upload: image.hex
	sudo /opt/microchip/mplabx/v4.01/mplab_ide/bin/mdb.sh $(TDIR)/upload.mdb

# Programming an image file onto a device

There's a wide variety of microcontrollers, development boards, and
device programmers.  To program a particular device, you have to
figure out which combination of hardware and software is needed.
Below are a few examples to get you started.

The output from the compiler is a flat binary file.  Some programming
software accept a binary file; other want an Intel HEX file.  There is
a makefile target to make this conversion.

### AVR

To program the image file onto a Adafruit Trinket board, use:

    avrdude -c usbtiny -p attiny85 -U flash:w:image:r -P usb

Programming the fuses is outside the scope of this manual.

### Cortex-M

To program an image onto a STM Nucleo-32, use:

    st-flash write image 0x08000000

### MSP430

To program an image onto a Launchpad board, use:

    mspdebug rf2500 "prog image.hex"

### PIC

To program an image onto a Curiosity board with a PIC16F1619, use the
supplied mdb script in the target/pic directory:

    mdb.sh upload.mdb

Programming the configuration bits is outside the scope of this
manual.

### STM8

To use an ST-Link V2 programmer to program an image onto a noname
STM8S103F3 board, use:

    stm8flash -C stlinkv2 -p stm8s103f3 -W image.hex

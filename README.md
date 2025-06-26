# lbForth Lite

This is a Forth cross compiler for tiny devices.  It's based on
[lbForth](http://github.com/larsbrinkhoff/lbForth).  Supported targets
are 8051, AVR, Cortex-M, MSP430, PIC, and STM8.  There's also support
for some classic machines: 6502, PDP-8, and IMLAC PDS-1.

This is a temporary battleground to get things up and running.  I
expect to fold the finished result back into lbForth.

The targets are tested using these simulators: naken_asm, uCsim,
simulavr, gpsim, simh, and thumbulator.  The status of the tests is:
[![Test](https://travis-ci.org/larsbrinkhoff/xForth.svg?branch=master)](https://travis-ci.org/larsbrinkhoff/xForth)

The compiler is suitable for parts with 1K program memory and 64 bytes
RAM.  The kernel code occupies 100-500 bytes, and it's recommended to
reserve about 24 bytes for the stacks.  At this size, only a bare
minimum of Forth words are supported.  All targets come with a prefix
assembler with its own unique syntax.

There is no resident interpreter or compiler in the target.  Things
are set up to provide target interaction through tethered operation,
but it's not implemented yet.  For now, the output is a flat binary
file.  ELF or Intel hex format can be made available on request.

The assemblers, compiler, and kernel are written in Forth and are all
very simple.  The user is encouraged to make modifications as see fit.

### Manual

[See here](doc/manual.md).

### Glossary 
 
Compile-time words:

    : ; [ ] CONSTANT VARIABLE CODE END-CODE
    ['] [CHAR] LITERAL
    IF THEN ELSE AHEAD BEGIN AGAIN UNTIL WHILE REPEAT

Run-time words:

    COLD WARM
    ! C! @ C@ +!
    DROP NIP DUP ?DUP SWAP OVER
    >R R> R@
    + - 2* 2/ INVERT NEGATE AND OR XOR 1+ 1- CELL+
    0= 0< 0<> = <>

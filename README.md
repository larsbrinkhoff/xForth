Forth cross compiler for tiny devices.  Supported targets are AVR and
MSP430.

This is a temporary battleground to get things up and running.  I
expect to fold the finished result back into
[lbForth](http://github.com/larsbrinkhoff/lbForth).

The compiler is suitable for parts with 1K program memory and 64 bytes
RAM.  The kernel code occupies 100-300 bytes, and it's recommended to
reserve about 24 bytes for the stacks.  At this size, only a bare
minimum of Forth words are supported.

There is no resident interpreter or compiler.  Things are set up to
provide target interaction through tethered operation, but it's not
implemented yet.  For now, the output is a flat binary file.  ELF or
Intel hex format can be made available on request.

The assemblers, compiler, and kernel are written in Forth and are all
very simple.  The user is encouraged to make modifications as see fit.

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
    + - 2* 2/ INVERT NEGATE XOR 1+ 1- CELL+
    0= 0<> = <>

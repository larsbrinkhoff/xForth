# Compiler internals

The compiler generates headerless STC code for all targets.  Code and
data are always put in separate memory areas.

The cell size is 12 bits for PDP-8, 16 bits for the 8 and 16 bit
parts, and 32 bits for Thumb parts.

### Register usage

|        | TOS   | SP  | RP  | Temporary
| ---    | ---   | --- | --- | ---
| 6502   |       | X   | SP  | A, Y
| 8051   | DPTR  | R0  | SP  | R1-R4
| AVR    | X     | Y   | SP  | R2-R3, Z
| MSP430 | R5    | R4  | R1  | R6
| PDP-8  | AC    | 10  | 11  | 5-7
| PIC    | 22-23 | 20  |     | 24-25, W
| STM8   |       | X   | SP  | A, Y
| Thumb  | R6    | R7  | SP  | R5, LR

### Memory map

All numbers are in hexadecimal, except for the PDP-8 which use octal.

|        | Program   | Data      | Data Stack | Return Stack | Temporary
| ---    | ---       | ---       | ---        | ---          | ---
| 6502   | 1000-FFFF | 0-        | E0-FF      | 100-1FF      | 42-43
| 8051   | 0-        | 100-      | -FF        | 10-          |
| AVR    | 0-        | 60-7F     | 80-8B      | 8C-9E        |
| MSP430 | F800-FFFF | 200-25F   | 270-27F    | 260-26F      |
| PDP-8  | 0-        | 4000-5777 | 6400-6777  | 6000-6377    |
| PIC    | 0-        | 28-2F     | 40-4F      |              | 30-3F
| STM8   | 8000-     | 0-1FF     | 200-2FF    | 300-3FF      |
| Thumb  | 0-        | 20000000- | -200006FF  | -200007FF    |

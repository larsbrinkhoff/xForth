
also assembler

: isr!  ( xt n - ) ( compile jmp instruction to isr routine )
    4 * t-image +           ( xt adr0 - )
    dup                     ( xt adr0 adr0 - )
    12 swap c!              ( xt adr0 - )
    1+                      ( xt adr1 - )
    dup                     ( xt adr1 adr1 - )
    148 swap c!             ( xt adr1 - )
    1+                      ( xt adr2 - )
    over 1 rshift over c!   ( xt adr2 - )
    1+                      ( xt adr3 - )
    swap 9 rshift swap c!
;

previous

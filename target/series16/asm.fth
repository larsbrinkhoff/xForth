DDP-116

000777 is sector address
001000 S, sector (1=this, 0=zero)
040000 T, indexing
100000 F, indirect
location 0 is X index register

indirect word, 37777 is address

000000 HLT, halt
000041 SCA, shift count to A
000043 INK, input keys              h516
000101 NRM, normalize
000201 IAB, interchange A and B
000401 ENB, enable interrupt
001001 INH, inhibit interrupt
002000 JMP, jump
004000 LDA, load A
006000 ANA, and with A
008000 STA, store A
012000 ERA, or with A
014000 ADD, add to A
016000 SUB, subtract from A
020000 JST, jump and store
022000 CAS, compare against A
024000 IRS, increment replace skip
026000 IMA, interchange A and memory
030000 OCP, output control pulse
032000 STX,                            h516
034000 MUL, multiply
036000 DIV, divide
040000 LRL, long logical shift right
040100 LRS, long arithmetic shift right
040200 LRR, long rotate right
040400 LGR, logical shift right
040500 ARS, arithmetic shift right
040600 ARR, rotate right
041000 LLL, long logical shift left
041100 LLS, long arithmetic shift left
041200 LLR, long rotate left
041400 LGL, logical shift left
041500 ALS, arithmetic shift left
041600 ALR, rotate left
072000 LDX,                            h516
070000 SKS, skip if ready line set
100000 SKP, skip
100001 SRC, skip if C reset
100002 SR4, skip if switch 4 reset
100004 SR3, skip if switch 3 reset
100010 SR2, skip if switch 2 reset
100020 SR1, skip if switch 1 reset
100036 SSR, skip if all switches reset
100040 SZE, skip if A zero
100100 SLZ, skip if A least bit zero
100400 SPL, skip if A positive
101000 NOP, no operation
101001 SSC, skip if C set
101002 SS4, skip if switch 4 set
101004 SS3, skip if switch 3 set
101010 SS2, skip if switch 2 set
101020 SS1, skip if switch 1 set
101036 SSS, skip if any switch set
101040 SNZ, skip if A not zero
101100 SLN, skip if A last bit not zero
101400 SMI, skip if A minus
130000 INA, input to A
130240 CCA, clear C and A
140024 CHS, complement sign A
140040 CRA, clear A
140100 SSP, set sign plus
140200 RCB, reset C
140320 CSA, copy sign
140401 CMA, complement A
140407 TCA, complement A
140500 SSM, set sign minus
140600 SCB, set C
141044 CAR,                     h516
141050 CAL,                     h516
141140 ICL,                     h516
141206 AOA, add 1 to A
141216 ACA, add C to A
141240 ICR                      h516
170000 OTA, output from A
171020 OTK,                     h516

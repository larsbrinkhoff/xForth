0 org

code cold
   warm();
end-code

code drop
   sp++;
end-code

code !
   cell_t x = *sp++;
   cell_t *a = (cell_t *)&mem[x];
   *a = *sp++;
end-code

code c!
   cell_t a = *sp++;
   mem[a] = *sp++;
end-code

code @
   cell_t x = *sp;
   cell_t *a = (cell_t *)&mem[x];
   *sp = *a;
end-code

code c@
   cell_t a = *sp;
   *sp = mem[a];
end-code

code dup
   cell_t x = *sp;
   *--sp = x;
end-code

code swap
   cell_t x = *sp;
   *sp = sp[1];
   sp[1] = x;
end-code

: nip   swap drop ;

code 2*
   *sp <<= 1;
end-code

code 2/
   *sp >>= 1;
end-code

code xor
   cell_t x = *sp++;
   *sp ^= x;
end-code

code or
   cell_t x = *sp++;
   *sp |= x;
end-code

code and
   cell_t x = *sp++;
   *sp &= x;
end-code

: ?dup   dup if dup then ;

code over
   cell_t x = sp[1];
   *--sp = x;
end-code

code >r
   *--rp = *sp++;
end-code

code r>
   *--sp = *rp++;
end-code

code 0=
   *sp = (*sp ? 0 : -1);
end-code

code 0<
   *sp = (*sp < 0 ? -1 : 0);
end-code

code +
   cell_t x = *sp++;
   *sp += x;
end-code

code 1+
   *sp += 1;
end-code

code cell+
   *sp += sizeof (cell_t);
end-code

code +!
   cell_t *a = (cell_t *)*sp++;
   *a += *sp++;
end-code

code r@
   *--sp = *rp;
end-code

code negate
   *sp = -*sp;
end-code

: -   negate + ;
: =   - 0= ;
: 0<>   0= 0= ;
: <>   - 0<> ;

code bye
   exit(0);
end-code

code panic
   exit(1);
end-code

target remote localhost:1212

define s
  si
  x/1i $pc
  printf "S=%d, ", 256*$r29 + $r28
  printf "R=%d, ", (int)$sp & 0xffff
  printf "T=%d\n", 256*$r31 + $r30
  x/4dh 256*$r29 + $r28
  x/4xh (int)$sp & 0xffff
end

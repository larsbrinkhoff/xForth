#include <stdio.h>

union word
{
  unsigned int i;
  unsigned char c;
};

int main (void)
{
  union word x;
  x.i = 1;
  printf ("%d constant t-little-endian\n", x.c);
  printf ("%ld constant t-cell\n", sizeof (int));
  return 0;
}

#include <err.h>
#include <stdio.h>

#include <corelib/scan.h>

int
main(int argc, char *argv[])
{
  unsigned long num;

  if (argc < 3) errx(2, "usage: num string");

  if (!scan_ulong(argv[1], &num))
    errx(2, "num must be numeric");

  for (;;) {
    if (!num) break;
    printf("%s\n", argv[2]);
    --num;
  }
  return 0;
}

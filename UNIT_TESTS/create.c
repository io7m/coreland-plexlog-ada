#include <sys/time.h>

#include <err.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

int
main(int argc, char *argv[])
{
  struct timeval t[2];
  FILE *fp;
  unsigned long size = 0;
  unsigned long age;
  int fd;

  if (argc < 3) errx(2, "usage: file age [size]");

  age = strtol (argv[2], 0, 10);
  if (!age) errx(2, "age must be numeric");  

  if (argc > 3) {
    size = strtol (argv[2], 0, 10);
  }

  fp = fopen(argv[1], "wb");
  if (!fp) err(2, "fopen");
  fd = fileno(fp);

  if (argc > 3) {
    for (;;) {
      if (!size) break;
      if (fwrite("\x0", 1, 1, fp) < 1) err(2, "fwrite");
      --size;
    }
    if (fflush(fp) != 0) err(2, "fflush");
  }

  if (gettimeofday(&t[0], 0) == -1) err(2, "gettimeofday");
  t[0].tv_sec -= age;
  t[1] = t[0];
  if (futimes(fd, t) == -1) err(2, "futimes");

  if (fclose(fp) != 0) err(2, "fclose");
  return 0;
}

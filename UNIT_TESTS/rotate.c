#include <err.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <corelib/scan.h>

#define PLEXLOG_IMPLEMENTATION
#include <plexlog/plexlog.h>

struct plexlog px;

int
main(int argc, char *argv[])
{
  char *file;
  unsigned int max_size;
  unsigned int max_files;

  if (argc != 4)
    errx(2, "usage: max_files max_size path");

  if (!scan_uint(argv[1], &max_files))
    errx(2, "fatal: max_files must be numeric");
  if (!scan_uint(argv[2], &max_size))
    errx(2, "fatal: max_size must be numeric");
  file = argv[3];

  if (!px_open(&px, file)) err(2, "fatal: px_open");
  if (!px_max_files(&px, max_files)) err(2, "fatal: px_max_files");
  if (!px_max_filesize(&px, max_size)) err(2, "fatal: px_max_filesize");
  if (!px_lock(&px)) err(2, "fatal: px_lock");
  if (!px_rotate(&px)) err(2, "fatal: px_rotate");
  if (!px_unlock(&px)) err(2, "fatal: px_unlock");
  return 0;
}

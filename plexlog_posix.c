#include <errno.h>

void
plexlog_posix_errno_set (int e)
{
  errno = e;
}

int
plexlog_posix_errno_get (void)
{
  return errno;
}

#include <corelib/error.h>

const char *
px_get_error_str (void)
{
  return error_str (errno);
}

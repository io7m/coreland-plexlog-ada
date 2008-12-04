#include <stdio.h>
#include <plexlog/plexlog.h>

int
main (void)
{
  printf ("  size_default : constant := %u;\n", PX_SIZE_DEFAULT);
  printf ("  size_min     : constant := %u;\n", PX_SIZE_MIN);
  printf ("  file_default : constant := %u;\n", PX_FILE_DEFAULT);
  return 0;
}

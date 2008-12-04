with interfaces.c;
with interfaces.c.strings;

package body dir is
  package c renames interfaces.c;
  package cs renames interfaces.c.strings;

  package cbinds is
    procedure mkdir
      (name : cs.chars_ptr;
       mode : c.unsigned);
    pragma import (c, mkdir, "mkdir");

    procedure rmdir (name : cs.chars_ptr);
    pragma import (c, rmdir, "rmdir");
  end cbinds;

  procedure mkdir
    (name : string;
     mode : natural)
  is
    c_name : aliased c.char_array := c.to_c (name);
  begin
    cbinds.mkdir
      (name => cs.to_chars_ptr (c_name'unchecked_access),
       mode => c.unsigned (mode));
  end mkdir;

  procedure rmdir (name : string) is
    c_name : aliased c.char_array := c.to_c (name);
  begin
    cbinds.rmdir (name => cs.to_chars_ptr (c_name'unchecked_access));
  end rmdir;

end dir;

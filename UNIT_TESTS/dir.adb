with Interfaces.C;
with Interfaces.C.Strings;

package body dir is
  package C renames Interfaces.C;
  package CS renames Interfaces.C.Strings;

  package cbinds is
    procedure mkdir
      (name : CS.chars_ptr;
       mode : C.unsigned);
    pragma Import (C, mkdir, "mkdir");

    procedure rmdir (name : CS.chars_ptr);
    pragma Import (C, rmdir, "rmdir");
  end cbinds;

  procedure mkdir
    (name : in string;
     mode : in natural)
  is
    c_name : aliased C.char_array := C.To_C (name);
  begin
    cbinds.mkdir
      (name => CS.To_Chars_Ptr (c_name'Unchecked_Access),
       mode => C.unsigned (mode));
  end mkdir;

  procedure rmdir (name : in string) is
    c_name : aliased C.char_array := C.To_C (name);
  begin
    cbinds.rmdir (name => CS.To_Chars_Ptr (c_name'Unchecked_Access));
  end rmdir;

end dir;

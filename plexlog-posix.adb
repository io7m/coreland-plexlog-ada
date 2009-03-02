with Interfaces.C.Strings;

package body Plexlog.POSIX is
  package C renames Interfaces.C;
  package CS renames C.Strings;

  use type C.int;

  package CBinds is
    function open
      (Path  : in CS.chars_ptr;
       Flags : in Open_Flags_t;
       Mode  : in Mode_t) return FD_t;
    pragma Import (C, open, "open");

    function fd_lock_w
      (FD : FD_t) return FD_t;
    pragma Import (C, fd_lock_w, "fd_lock_w");

    function fd_unlock_w
      (FD : FD_t) return FD_t;
    pragma Import (C, fd_unlock_w, "fd_unlock_w");

    function rename
      (From : CS.chars_ptr;
       To   : CS.chars_ptr) return C.int;
    pragma Import (C, rename, "rename");

    function fchdir (FD : FD_t) return C.int;
    pragma Import (C, fchdir, "fchdir");

    function close (FD : FD_t) return C.int;
    pragma Import (C, close, "close");
  end CBinds;

  function Close (FD : FD_t) return Boolean is
  begin
    return CBinds.close (FD) /= -1;
  end Close;

  procedure Close (FD : FD_t) is
    pragma Warnings (off); -- unreferenced constant
    OK : constant Boolean := Close (FD);
    pragma Warnings (on);
  begin
    null;
  end Close;

  function Open_Read (Path : in String) return FD_t is
    cpath : aliased C.char_array := C.To_C (Path);
  begin
    return CBinds.open
      (Path  => CS.To_Chars_Ptr (cpath'Unchecked_Access),
       Flags => Open_Flag_Read_Only,
       Mode  => Mode_User_RX);
  end Open_Read;

  function Open_Create
    (Path : in String;
     Mode : Mode_t := (Mode_User_RW or Mode_Group_R or Mode_Other_R))
      return FD_t
  is
    cpath : aliased C.char_array := C.To_C (Path);
  begin
    return CBinds.open
      (Path  => CS.To_Chars_Ptr (cpath'Unchecked_Access),
       Flags => Open_Flag_Write_Only or Open_Flag_Create,
       Mode  => Mode);
  end Open_Create;

  function FD_Write_Lock (FD : FD_t) return Boolean is
  begin
    return CBinds.fd_lock_w (FD) /= Invalid_FD;
  end FD_Write_Lock;

  function FD_Write_Unlock (FD : FD_t) return Boolean is
  begin
    return CBinds.fd_unlock_w (FD) /= Invalid_FD;
  end FD_Write_Unlock;

  function FD_Change_Directory (FD : FD_t) return Boolean is
  begin
    return CBinds.fchdir (FD) /= -1;
  end FD_Change_Directory;

  function Rename
    (From : in String;
     To   : in String) return Boolean
  is
    cfrom : aliased C.char_array := C.To_C (From);
    cto   : aliased C.char_array := C.To_C (To);
  begin
    return CBinds.rename
      (From => CS.To_Chars_Ptr (cfrom'Unchecked_Access),
       To   => CS.To_Chars_Ptr (cto'Unchecked_Access)) /= -1;
  end Rename;

end Plexlog.POSIX;

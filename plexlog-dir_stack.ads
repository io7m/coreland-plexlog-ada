with Plexlog.POSIX;

pragma Elaborate_All (Plexlog.POSIX);

package Plexlog.Dir_Stack is

  type Dir_Stack_t is limited private;

  procedure Push_FD
    (Stack : in out Dir_Stack_t;
     FD    : in Plexlog.POSIX.FD_t);

  procedure Push
    (Stack : in out Dir_Stack_t;
     Path  : in String);

  procedure Pop
    (Stack : in out Dir_Stack_t);

  procedure Pop_All
    (Stack : in out Dir_Stack_t);

  function Size
    (Stack : in Dir_Stack_t) return Natural;

  Push_Error : exception;
  Pop_Error  : exception;

private
  package POSIX renames Plexlog.POSIX;

  type FD_Array_Count_t is range 0 .. 4;
  subtype FD_Array_Index_t is FD_Array_Count_t range 1 .. FD_Array_Count_t'Last;
  type FD_Array_t is array (FD_Array_Index_t) of POSIX.FD_t;

  type Dir_Stack_t is record
    Index    : FD_Array_Index_t := FD_Array_Index_t'First;
    FD_Array : FD_Array_t       := (others => POSIX.Invalid_FD);
  end record;

end Plexlog.Dir_Stack;

with Ada.Streams.Stream_IO;
with Plexlog.Dir_Stack;
with Plexlog.POSIX;
with chrono.TAIA;

pragma Elaborate_All (Ada.Streams.Stream_IO);
pragma Elaborate_All (Plexlog.Dir_Stack);
pragma Elaborate_All (Plexlog.POSIX);
pragma Elaborate_All (chrono.TAIA);

package Plexlog.API is

  type Level_t is
    (Log_None,
     Log_Debug,
     Log_Info,
     Log_Notice,
     Log_Warn,
     Log_Error,
     Log_Fatal,
     Log_Audit);

  Size_Default  : constant := 1024 * 1024;
  Size_Min      : constant := 50;
  Files_Default : constant := 10;

  type Plexlog_t is limited private;

  subtype File_Size_t is Long_Integer range Size_Min .. Long_Integer'Last;

  Close_Error  : exception;
  Lock_Error   : exception;
  Open_Error   : exception;
  Rotate_Error : exception;
  Write_Error  : exception;

  procedure Open
    (Context : in out Plexlog_t;
     Path    : in String);

  procedure Set_Maximum_Saved_Files
    (Context   : in out Plexlog_t;
     Max_Files : in Natural);

  procedure Set_Maximum_File_Size
    (Context       : in out Plexlog_t;
     Max_File_Size : in File_Size_t);

  procedure Set_Unlimited_File_Size
    (Context : in out Plexlog_t);

  procedure Write
    (Context : in out Plexlog_t;
     Data    : in String;
     Level   : in Level_t := Log_None);

  procedure Close
    (Context : in out Plexlog_t);

  subtype Long_Positive is Long_Integer range 1 .. Long_Integer'Last;

  function Space_Requirement
    (Max_Files : in Long_Positive;
     Max_Size  : in Long_Positive) return Long_Positive;

private
  package POSIX renames Plexlog.POSIX;

  -- Example format:
  -- @4000000047d18117009557a4 4294967295 notice: <LF>

  Message_Minimum_Length : constant :=
    1 + chrono.TAIA.Label_TAI64N_Size + 1 + 10 + 1 + 7 + 1;

  type Plexlog_t is record
    Size_Limited : Boolean                          := True;
    Size_Max     : File_Size_t                      := Size_Default;
    Files_Max    : Natural                          := Files_Default;
    Log_Dir_FD   : POSIX.FD_t                       := POSIX.Invalid_FD;
    Lock_FD      : POSIX.FD_t                       := POSIX.Invalid_FD;
    Log_File     : Ada.Streams.Stream_IO.File_Type;
    Log_Size     : Ada.Streams.Stream_IO.Count      := 0;
    Dir_Stack    : Plexlog.Dir_Stack.Dir_Stack_t;
  end record;

  function Have_Directory_Lock (Context : in Plexlog_t) return Boolean;

end Plexlog.API;

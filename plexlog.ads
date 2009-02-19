with Interfaces.C;

package Plexlog is

  type Level_t is
    (Log_None,
     Log_Debug,
     Log_Info,
     Log_Notice,
     Log_Warn,
     Log_Error,
     Log_Fatal);

  Size_Default : constant := 99999;
  Size_Min     : constant := 4096;
  File_Default : constant := 10;

  type Plexlog_t is limited private;

  subtype File_Size_t is range Size_Min .. Long_Integer'Last;

  Open_Error   : exception;
  Write_Error  : exception;
  Close_Error  : exception;
  Rotate_Error : exception;

  procedure Open
    (Context : in out Plexlog_t;
     Path    : in string);

  procedure Set_Maximum_Files
    (Context   : in out Plexlog_t;
     Max_Files : in Natural);

  procedure Set_Maximum_File_Size
    (Context      : in out Plexlog_t;
     Max_File_Size : in File_Size_t);

  procedure Write
    (Context : in out Plexlog_t;
     Level   : in Level_t;
     Data    : in string);

  procedure Rotate
    (Context : in out Plexlog_t);

  procedure Close
    (Context : in out Plexlog_t);

private
  package C renames Interfaces.C;

  type FD_t is new C.int;

  Invalid_FD : constant FD_t := -1;

  type Plexlog_t is record
    Size_Max   : File_Size_t;
    File_Max   : Natural;
    Log_Dir_FD : FD_t := -1;
    Lock_FD    : FD_t := -1;
  end record;

end Plexlog;

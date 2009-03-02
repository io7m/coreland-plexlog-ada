with Interfaces.C;

package Plexlog.POSIX is

  type Open_Flags_t is new Interfaces.C.unsigned;

  Open_Flag_Read_Only  : constant Open_Flags_t := 16#0000#;
  Open_Flag_Write_Only : constant Open_Flags_t := 16#0001#;
  Open_Flag_Create     : constant Open_Flags_t := 16#0200#;

  type Mode_t is new Interfaces.C.unsigned;

  Mode_User_R    : constant Mode_t := 8#0400#;
  Mode_User_W    : constant Mode_t := 8#0200#;
  Mode_User_X    : constant Mode_t := 8#0100#;
  Mode_User_RW   : constant Mode_t := Mode_User_R or Mode_User_W;
  Mode_User_RWX  : constant Mode_t := Mode_User_R or Mode_User_W or Mode_User_X;
  Mode_User_RX   : constant Mode_t := Mode_User_R or Mode_User_X;

  Mode_Group_R   : constant Mode_t := 8#0040#;
  Mode_Group_W   : constant Mode_t := 8#0020#;
  Mode_Group_X   : constant Mode_t := 8#0010#;
  Mode_Group_RW  : constant Mode_t := Mode_Group_R or Mode_Group_W;
  Mode_Group_RWX : constant Mode_t := Mode_Group_R or Mode_Group_W or Mode_Group_X;
  Mode_Group_RX  : constant Mode_t := Mode_Group_R or Mode_Group_X;

  Mode_Other_R   : constant Mode_t := 8#0004#;
  Mode_Other_W   : constant Mode_t := 8#0002#;
  Mode_Other_X   : constant Mode_t := 8#0001#;
  Mode_Other_RW  : constant Mode_t := Mode_Other_R or Mode_Other_W;
  Mode_Other_RWX : constant Mode_t := Mode_Other_R or Mode_Other_W or Mode_Other_X;
  Mode_Other_RX  : constant Mode_t := Mode_Other_R or Mode_Other_X;

  type Error_t is new Interfaces.C.int;
  type FD_t is new Interfaces.C.int;
  type PID_t is new Interfaces.C.int;

  Invalid_FD : constant FD_t := -1;

  function Open_Read (Path : in String) return FD_t;
  pragma Inline (Open_Read);

  function Open_Create
    (Path : in String;
     Mode : Mode_t := (Mode_User_RW or Mode_Group_R or Mode_Other_R)) return FD_t;
  pragma Inline (Open_Create);

  function Close (FD : FD_t) return Boolean;
  procedure Close (FD : FD_t);
  pragma Inline (Close);

  function FD_Write_Lock (FD : FD_t) return Boolean;
  pragma Inline (FD_Write_Lock);

  function FD_Write_Unlock (FD : FD_t) return Boolean;
  pragma Inline (FD_Write_Unlock);

  function FD_Change_Directory (FD : FD_t) return Boolean;
  pragma Inline (FD_Change_Directory);

  function Get_PID return PID_t;
  pragma Import (C, Get_PID, "getpid");

  function Rename
    (From : in String;
     To   : in String) return Boolean;
  pragma Inline (Rename);

  procedure Errno_Set (Code : in Error_t);
  pragma Import (C, Errno_Set, "plexlog_posix_errno_set");

  function Errno_Get return Error_t;
  pragma Import (C, Errno_Get, "plexlog_posix_errno_get");

end Plexlog.POSIX;

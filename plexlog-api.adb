with Ada.Calendar;
with Ada.Characters.Latin_1;
with Ada.Containers.Indefinite_Vectors;
with Ada.Directories;
with Ada.Streams;
with Ada.Strings.Fixed;
with Ada.Strings;
with Ada.Unchecked_Conversion;

package body Plexlog.API is
  package Calendar renames Ada.Calendar;
  package Directories renames Ada.Directories;
  package F_Strings renames Ada.Strings.Fixed;
  package Stream_IO renames Ada.Streams.Stream_IO;
  package Streams renames Ada.Streams;
  package Strings renames Ada.Strings;

  use type POSIX.FD_t;
  use type Stream_IO.Count;

  --
  -- Log file is currently locked?
  --

  function Have_Directory_Lock (Context : in Plexlog_t) return Boolean is
  begin
    return Context.Lock_FD /= POSIX.Invalid_FD;
  end Have_Directory_Lock;

  --
  -- Acquire write lock.
  --

  procedure Lock_Directory (Context : in out Plexlog_t) is
    pragma Assert (not Have_Directory_Lock (Context));
  begin
    Dir_Stack.Push_FD (Context.Dir_Stack, Context.Log_Dir_FD);

    Context.Lock_FD := POSIX.Open_Create ("lock");
    if Context.Lock_FD = POSIX.Invalid_FD then
      raise Lock_Error with "could not open lock";
    end if;

    if not POSIX.FD_Write_Lock (Context.Lock_FD) then
      raise Lock_Error with "could not set lock on file";
    end if;
  exception
    when Dir_Stack.Push_Error =>
      raise Lock_Error with "could not switch to log directory";
    when Lock_Error =>
      POSIX.Close (Context.Lock_FD);
      Dir_Stack.Pop (Context.Dir_Stack);
      raise;
  end Lock_Directory;

  --
  -- Relinquish write lock.
  --

  procedure Unlock_Directory (Context : in out Plexlog_t) is
    pragma Assert (Have_Directory_Lock (Context));
    pragma Assert (Dir_Stack.Size (Context.Dir_Stack) > 0);
  begin
    Dir_Stack.Pop (Context.Dir_Stack);

    if not POSIX.FD_Write_Unlock (Context.Lock_FD) then
      raise Lock_Error with "could not unlock file";
    end if;

    if not POSIX.Close (Context.Lock_FD) then
      raise Lock_Error with "could not close lock descriptor";
    end if;

    Context.Lock_FD := POSIX.Invalid_FD;
  exception
    when Dir_Stack.Pop_Error =>
      raise Lock_Error with "could not remove old directory descriptor";
  end Unlock_Directory;

  --
  -- File information type.
  --

  type Log_File_t (Length : Positive) is record
    Name              : String (1 .. Length);
    Modification_Time : Calendar.Time;
  end record;

  function Log_File_Compare
    (Left  : in Log_File_t;
     Right : in Log_File_t) return Boolean
  is
    use type Calendar.Time;
  begin
    return Left.Modification_Time > Right.Modification_Time;
  end Log_File_Compare;

  package Log_File_Vectors is new Ada.Containers.Indefinite_Vectors
    (Index_Type   => Natural,
     Element_Type => Log_File_t);

  package Log_File_Vectors_Sorting is new
    Log_File_Vectors.Generic_Sorting (Log_File_Compare);

  --
  -- Remove oldest log files.
  --

  procedure Rotate_Remove_Old (Context : in Plexlog_t) is
    pragma Assert (Have_Directory_Lock (Context));
    pragma Assert (not Stream_IO.Is_Open (Context.Log_File));
    pragma Assert (Context.Files_Max > 0);

    Log_List : Log_File_Vectors.Vector;

    -- Collect current log files.
    procedure Collect_Log_File
      (Dir_Entry : in Directories.Directory_Entry_Type)
    is
      Name : constant String := Directories.Simple_Name (Dir_Entry);
    begin
      if Name (1) = '@' then
        declare
          Log_File : constant Log_File_t (Length => Name'Length) :=
            (Length            => Name'Length,
             Name              => Name,
             Modification_Time => Directories.Modification_Time (Dir_Entry));
        begin
          Log_File_Vectors.Append
            (Container => Log_List,
             New_Item  => Log_File);
        end;
      end if;
    end Collect_Log_File;

    -- Delete log file
    procedure Remove_Log (File : in Log_File_t) is
    begin
      Directories.Delete_File (File.Name);
    end Remove_Log;

  begin
    -- Collect names and times of all log files.
    Directories.Search
      (Directory => Directories.Current_Directory,
       Pattern   => "",
       Filter    => (Directories.Ordinary_File => True, others => False),
       Process   => Collect_Log_File'Access);

    -- Sort collected log files by date.
    Log_File_Vectors_Sorting.Sort (Log_List);

    -- Select and remove all log files over Files_Max
    declare
      Num_Files : constant Natural := Natural (Log_File_Vectors.Length (Log_List));
      Max_Files : constant Natural := Context.Files_Max - 1; -- ignore 'current'
    begin
      if Num_Files >= Max_Files then
        for Index in Max_Files .. Num_Files - 1 loop
          Log_File_Vectors.Query_Element
            (Container => Log_List,
             Index     => Index,
             Process   => Remove_Log'Access);
        end loop;
      end if;
    end;
  end Rotate_Remove_Old;

  --
  -- Remove old log files and rename current to a timestamp
  --

  procedure Rotate
    (Context : in out Plexlog_t)
  is
    pragma Assert (Have_Directory_Lock (Context));
    pragma Assert (not Stream_IO.Is_Open (Context.Log_File));

    TAIA       : chrono.TAIA.TAIA_t;
    TAIA_Label : chrono.TAIA.Label_TAI64N_t;
  begin
    chrono.TAIA.Now (TAIA);
    chrono.TAIA.Label_TAI64N (TAIA, TAIA_Label);

    -- Remove old log files if number of files is limited.
    if Context.Files_Max > 0 then
      Rotate_Remove_Old (Context);
    end if;

    Rename_Current : declare
      Label_String : constant String := "@" & String (TAIA_Label);
    begin
      if not POSIX.Rename ("current", "@" & String (TAIA_Label)) then
        raise Rotate_Error with "could not rename current to " & Label_String;
      end if;
    end Rename_Current;
  end Rotate;

  --
  -- Character -> NN base16.
  --

  procedure Character_To_Hex
    (Value  : in Character;
     Buffer : out String)
  is
    Hex_Table : constant String := "0123456789abcdef";
    Int_Value : constant Natural := Character'Pos (Value);
  begin
    Buffer (Buffer'First) := Hex_Table (1 + ((Int_Value / 16) mod 16));
    Buffer (Buffer'First + 1) := Hex_Table (1 + (Int_Value mod 16));
  end Character_To_Hex;
  pragma Inline (Character_To_Hex);

  --
  -- Filter Character.
  --

  type Character_Width_t is range 1 .. 4;
  type Character_Buffer_t is array
    (Character_Width_t'First .. Character_Width_t'Last) of Character;

  procedure Filter_Character
    (Item   : in Character;
     Write  : in Boolean := True;
     Length : out Positive;
     Buffer : out Character_Buffer_t)
  is
    Character_High : constant Character := Ada.Characters.Latin_1.DEL;
    Character_Low  : constant Character := Ada.Characters.Latin_1.US;
  begin
    -- Character out of printable ASCII range
    if (Item <= Character_Low) or (Item >= Character_High) then
      if Write then
        Buffer (1) := '\';
        Buffer (2) := 'x';
        Character_To_Hex (Item, String (Buffer (3 .. 4)));
      end if;
      if Character'Pos (Item) >= 16#0f# then
        Length := 4;
      else
        Length := 3;
      end if;
      return;
    end if;

    -- Escape slashes
    if Item = '\' then
      if Write then
        Buffer (1) := '\';
        Buffer (2) := '\';
      end if;
      Length := 2;
      return;
    end if;

    -- Ordinary printable ASCII
    if Write then
      Buffer (1) := Item;
    end if;
    Length := 1;
  end Filter_Character;

  --
  -- Get length of message after filtering.
  --

  function Filtered_Message_Length (Data : in String) return Natural is
    Current_Length     : Natural;
    Accumulated_Length : Natural := 0;
    Buffer             : Character_Buffer_t;
  begin
    for Index in Data'Range loop
      Filter_Character
        (Item   => Data (Index),
         Write  => False,
         Length => Current_Length,
         Buffer => Buffer);
      Accumulated_Length := Accumulated_Length + Current_Length;
    end loop;
    return Accumulated_Length;
  end Filtered_Message_Length;

  --
  -- Return String associated with level
  --

  type String_Access_t is access constant String;

  Log_None_String   : aliased constant String := "";
  Log_Debug_String  : aliased constant String := "debug";
  Log_Info_String   : aliased constant String := "info";
  Log_Notice_String : aliased constant String := "notice";
  Log_Warn_String   : aliased constant String := "warn";
  Log_Error_String  : aliased constant String := "error";
  Log_Fatal_String  : aliased constant String := "fatal";
  Log_Audit_String  : aliased constant String := "audit";

  Level_Strings : constant array (Level_t range <>) of String_Access_t :=
    (Log_None   => Log_None_String'Access,
     Log_Debug  => Log_Debug_String'Access,
     Log_Info   => Log_Info_String'Access,
     Log_Notice => Log_Notice_String'Access,
     Log_Warn   => Log_Warn_String'Access,
     Log_Error  => Log_Error_String'Access,
     Log_Fatal  => Log_Fatal_String'Access,
     Log_Audit  => Log_Audit_String'Access);

  function Level_String
    (Level : in Level_t) return String is
  begin
    return Level_Strings (Level).all;
  end Level_String;

  --
  -- Convenience functions
  --

  function Log_Is_Empty
    (Context : in Plexlog_t) return Boolean
  is
    pragma Assert (Stream_IO.Is_Open (Context.Log_File));
  begin
    return Context.Log_Size = 0;
  end Log_Is_Empty;
  pragma Inline (Log_Is_Empty);

  function Log_Has_Space_For
    (Context : in Plexlog_t;
     Length  : in Natural) return Boolean
  is
    pragma Assert (Stream_IO.Is_Open (Context.Log_File));
  begin
    return (Context.Log_Size + Stream_IO.Count (Length)
      + Message_Minimum_Length) < Stream_IO.Count (Context.Size_Max);
  end Log_Has_Space_For;
  pragma Inline (Log_Has_Space_For);

  --
  -- Open/create 'current' log file.
  --

  procedure Open_Current (Context : in out Plexlog_t) is
    pragma Assert (Have_Directory_Lock (Context));
    pragma Assert (not Stream_IO.Is_Open (Context.Log_File));
  begin
    begin
      Stream_IO.Open
        (File => Context.Log_File,
         Mode => Stream_IO.Append_File,
         Name => "current");
    exception
      when Stream_IO.Name_Error =>
        Stream_IO.Create
         (File => Context.Log_File,
          Mode => Stream_IO.Append_File,
          Name => "current");
    end;
    Context.Log_Size := Stream_IO.Size (Context.Log_File);
  end Open_Current;

  --
  -- Stream write.
  --

  procedure Write_Raw
    (Context : in Plexlog_t;
     Data    : in String)
  is
    pragma Assert (Have_Directory_Lock (Context));
    pragma Assert (Stream_IO.Is_Open (Context.Log_File));

    subtype Source is String (1 .. Data'Last);
    subtype Target is Streams.Stream_Element_Array
      (1 .. Streams.Stream_Element_Offset (Data'Last));
    function Convert is new Ada.Unchecked_Conversion (Source, Target);
  begin
    Stream_IO.Write
      (File => Context.Log_File,
       Item => Convert (Data));
  end Write_Raw;

  --
  -- Write log line prefix.
  --

  procedure Write_Line_Prefix
    (Context      : in out Plexlog_t;
     Level_String : in String := "";
     PID_String   : in String;
     TAIA_Label   : in chrono.TAIA.Label_TAI64N_t)
  is
    pragma Assert (Have_Directory_Lock (Context));
    pragma Assert (Stream_IO.Is_Open (Context.Log_File));
  begin
    if Level_String /= "" then
      Write_Raw
        (Context => Context,
         Data    => "@" & String (TAIA_Label) & " " & PID_String & " " & Level_String & ": ");
    else
      Write_Raw
        (Context => Context,
         Data    => "@" & String (TAIA_Label) & " " & PID_String);
    end if;
  end Write_Line_Prefix;

  --
  -- Write message, returning number of bytes processed and written.
  --

  type Log_Status_t is record
    Characters_Written   : Natural;
    Characters_Processed : Natural;
  end record;

  procedure Write_Message
    (Context : in out Plexlog_t;
     Message : in String;
     Limit   : in Natural := 0;
     Status  : out Log_Status_t)
  is
    pragma Assert (Have_Directory_Lock (Context));
    pragma Assert (Stream_IO.Is_Open (Context.Log_File));

    Filtered_Length : Natural;
    Buffer          : Character_Buffer_t;
  begin
    Status.Characters_Processed := 0;
    Status.Characters_Written   := 0;

    for Index in Message'Range loop
      Filter_Character
        (Item   => Message (Index),
         Write  => True,
         Length => Filtered_Length,
         Buffer => Buffer);
      if Limit > 0 then
        exit when Status.Characters_Written + Filtered_Length >= Limit;
      end if;

      declare
        Min : constant Character_Width_t := Buffer'First;
        Max : constant Character_Width_t := Character_Width_t (Filtered_Length);
      begin
        Write_Raw
          (Context => Context,
           Data    => String (Buffer (Min .. Max)));
      end;

      Status.Characters_Processed := Status.Characters_Processed + 1;
      Status.Characters_Written   := Status.Characters_Written + Filtered_Length;
    end loop;

    Write_Raw (Context, "" & Ada.Characters.Latin_1.LF);
    Stream_IO.Flush (Context.Log_File);
  end Write_Message;

  --
  -- Write log data, rotating log files if necessary.
  --

  procedure Write_With_Rotate
    (Context      : in out Plexlog_t;
     Level_String : in String;
     TAIA_Label   : in chrono.TAIA.Label_TAI64N_t;
     PID_String   : in String;
     Data         : in String)
  is
    pragma Assert (Have_Directory_Lock (Context));
    pragma Assert (Stream_IO.Is_Open (Context.Log_File));

    Max_Length      : constant Natural := Natural (Context.Size_Max) - Message_Minimum_Length;
    Filtered_Length : Natural := Filtered_Message_Length (Data);
    Current_Offset  : Natural := 0;
  begin
    -- Message cannot fit completely within remaining space.
    if not Log_Has_Space_For (Context, Filtered_Length) then

      -- Current log file requires rotation?
      if not Log_Is_Empty (Context) then
        Stream_IO.Close (Context.Log_File);
        Rotate (Context);
        Open_Current (Context);
      end if;

      -- Split message across as many log files as is required.
      Write_Loop : loop

        -- Message will fit in log file without splitting?
        exit Write_Loop when Log_Has_Space_For (Context, Filtered_Length);

        -- Write line prefix.
        Write_Line_Prefix
          (Context      => Context,
           Level_String => Level_String,
           PID_String   => PID_String,
           TAIA_Label   => TAIA_Label);

        -- Write as much data as current log file limit allows.
        declare
          Status : Log_Status_t;
        begin
          Write_Message
            (Context => Context,
             Message => Data (Data'First + Current_Offset .. Data'Last),
             Limit   => Max_Length,
             Status  => Status);
          Current_Offset  := Current_Offset + Status.Characters_Processed;
          Filtered_Length := Filtered_Message_Length
            (Data (Data'First + Current_Offset .. Data'Last));
        end;

        -- Close current log file.
        Stream_IO.Close (Context.Log_File);

        -- Create new log file.
        Rotate (Context);
        Open_Current (Context);

      end loop Write_Loop;
    end if;

    -- Write remaining data, if any.
    if Data (Data'First + Current_Offset .. Data'Last)'Length > 0 then

      -- Write line prefix.
      Write_Line_Prefix
        (Context      => Context,
         Level_String => Level_String,
         PID_String   => PID_String,
         TAIA_Label   => TAIA_Label);

      -- Write message, no splitting.
      declare
        Status : Log_Status_t;
      begin
        Write_Message
          (Context => Context,
           Message => Data (Data'First + Current_Offset .. Data'Last),
           Status  => Status);
      end;
    end if;
  end Write_With_Rotate;

  --
  -- API
  --

  procedure Open
    (Context : in out Plexlog_t;
     Path    : in String)
  is
    pragma Assert (not Have_Directory_Lock (Context));
    pragma Assert (not Stream_IO.Is_Open (Context.Log_File));
  begin
    Context.Log_Dir_FD := POSIX.Open_Read (Path);
    if Context.Log_Dir_FD = POSIX.Invalid_FD then
      raise Open_Error;
    end if;
  end Open;

  procedure Set_Maximum_Saved_Files
    (Context   : in out Plexlog_t;
     Max_Files : in Natural) is
  begin
    Context.Files_Max := Max_Files;
  end Set_Maximum_Saved_Files;

  procedure Set_Maximum_File_Size
    (Context       : in out Plexlog_t;
     Max_File_Size : in File_Size_t) is
  begin
    Context.Size_Max     := Max_File_Size;
    Context.Size_Limited := True;
  end Set_Maximum_File_Size;

  procedure Set_Unlimited_File_Size
    (Context : in out Plexlog_t) is
  begin
    Context.Size_Limited := False;
  end Set_Unlimited_File_Size;

  procedure Write
    (Context : in out Plexlog_t;
     Data    : in String;
     Level   : in Level_t := Log_None)
  is
    pragma Assert (not Have_Directory_Lock (Context));
    pragma Assert (not Stream_IO.Is_Open (Context.Log_File));

    TAIA       : chrono.TAIA.TAIA_t;
    TAIA_Label : chrono.TAIA.Label_TAI64N_t;
  begin
    chrono.TAIA.Now (TAIA);
    chrono.TAIA.Label_TAI64N (TAIA, TAIA_Label);

    Lock_Directory (Context);
    Open_Current (Context);

    if Context.Size_Limited then
      Write_With_Rotate
        (Context      => Context,
         Level_String => Level_String (Level),
         TAIA_Label   => TAIA_Label,
         PID_String   => F_Strings.Trim (POSIX.PID_t'Image (POSIX.Get_PID), Strings.Left),
         Data         => Data);
    else
      Write_Line_Prefix
        (Context      => Context,
         Level_String => Level_String (Level),
         PID_String   => F_Strings.Trim (POSIX.PID_t'Image (POSIX.Get_PID), Strings.Left),
         TAIA_Label   => TAIA_Label);

      declare
        Status : Log_Status_t;
      begin
        Write_Message
          (Context => Context,
           Message => Data,
           Status  => Status);
        pragma Assert (Status.Characters_Processed = Data'Length);
      end;
    end if;

    pragma Assert (Stream_IO.Is_Open (Context.Log_File));
    Stream_IO.Close (Context.Log_File);

    Unlock_Directory (Context);
    pragma Assert (not Stream_IO.Is_Open (Context.Log_File));
  exception
    when others =>
      pragma Assert (not Stream_IO.Is_Open (Context.Log_File));
      if Have_Directory_Lock (Context) then
        Unlock_Directory (Context);
      end if;
      raise;
  end Write;

  procedure Close
    (Context : in out Plexlog_t) is
  begin
    if Context.Log_Dir_FD /= POSIX.Invalid_FD then
      POSIX.Close (Context.Log_Dir_FD);
    end if;
    if Context.Lock_FD /= POSIX.Invalid_FD then
      POSIX.Close (Context.Lock_FD);
    end if;
  end Close;

  function Space_Requirement
    (Max_Files : in Long_Positive;
     Max_Size  : in Long_Positive) return Long_Positive is
  begin
    return (Max_Files * Max_Size) + Max_Size;
  end Space_Requirement;

end Plexlog.API;

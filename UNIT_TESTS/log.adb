with Ada.Command_Line;
with Ada.IO_Exceptions;
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with getline;
with Plexlog.API;

procedure log is
  package IO renames Ada.Text_IO;
  package UStrings renames Ada.Strings.Unbounded;

  max_files : natural;
  max_size  : Plexlog.API.File_Size_t;
  line      : UStrings.Unbounded_String;
  context   : Plexlog.API.Plexlog_t;

begin
  if Ada.Command_Line.Argument_Count /= 3 then
    IO.Put_Line (IO.Current_Error, "usage: dir max_file max_size");
    raise program_error;
  end if;

  max_files := natural'Value (Ada.Command_Line.Argument (2));
  max_size  := Plexlog.API.File_Size_t'Value (Ada.Command_Line.Argument (3));

  Plexlog.API.Open (context, Ada.Command_Line.Argument (1));
  Plexlog.API.Set_Maximum_Files (context, max_files);
  Plexlog.API.Set_Maximum_File_Size (context, max_size);

  begin
    loop
      getline.get (IO.Current_Input, line);
      Plexlog.API.Write (context, Plexlog.API.Log_Info, UStrings.To_String (line));
      UStrings.Set_Unbounded_String (line, "");
    end loop;
  exception
    when Ada.IO_Exceptions.End_Error => null;
  end;

end log;

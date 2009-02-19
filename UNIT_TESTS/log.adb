with Ada.Command_Line;
with Ada.IO_Exceptions;
with Ada.Strings.Unbounded;
with Ada.Text_IO;
with getline;
with plexlog;

procedure log is
  package IO renames Ada.Text_IO;
  package UStrings renames Ada.Strings.Unbounded;

  max_files : natural;
  max_size  : natural;
  line      : UStrings.Unbounded_String;
  context   : plexlog.plexlog_t;

begin
  if Ada.Command_Line.Argument_Count /= 3 then
    IO.Put_Line (IO.Current_Error, "usage: dir max_file max_size");
    raise program_error;
  end if;

  max_files := natural'Value (Ada.Command_Line.Argument (2));
  max_size  := natural'Value (Ada.Command_Line.Argument (3));

  plexlog.open (context, Ada.Command_Line.Argument (1));
  plexlog.max_files (context, max_files);
  plexlog.max_filesize (context, max_size);

  begin
    loop
      getline.get (IO.Current_Input, line);
      plexlog.write (context, plexlog.LOG_INFO, UStrings.To_String (line));
      UStrings.Set_Unbounded_String (line, "");
    end loop;
  exception
    when Ada.IO_Exceptions.End_Error => null;
  end;

end log;

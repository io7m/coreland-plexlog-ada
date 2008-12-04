with ada.command_line;
with ada.io_exceptions;
with ada.strings.unbounded;
with ada.text_io;
with getline;
with plexlog;

procedure log is
  package cmdline renames ada.command_line;
  package io renames ada.text_io;
  package us renames ada.strings.unbounded;

  max_files : natural;
  max_size  : natural;
  line      : us.unbounded_string;
  context   : plexlog.plexlog_t;

begin
  if cmdline.argument_count /= 3 then
    io.put_line (io.current_error, "usage: dir max_file max_size");
    raise program_error;
  end if;

  max_files := natural'value (cmdline.argument (2));
  max_size  := natural'value (cmdline.argument (3));

  plexlog.open (context, cmdline.argument (1));
  plexlog.max_files (context, max_files);
  plexlog.max_filesize (context, max_size);

  begin
    loop
      getline.get (io.current_input, line);
      plexlog.write (context, plexlog.log_info, us.to_string (line));
      us.set_unbounded_string (line, "");
    end loop;
  exception
    when ada.io_exceptions.end_error => null;
  end;

end log;

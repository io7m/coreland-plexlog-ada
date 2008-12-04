with dir;
with plexlog;
with test;

procedure t_init1 is

  open_ok  : boolean := true;
  close_ok : boolean := true;
  context  : plexlog.plexlog_t;

begin
  dir.rmdir ("testdata/init");
  dir.mkdir ("testdata/init", 8#0755#);

  begin
    plexlog.open (context, "testdata/init");
    plexlog.close (context);
  exception
    when plexlog.open_error => open_ok := false;
    when plexlog.close_error => close_ok := false;
  end;

  test.assert
    (check        => open_ok,
     pass_message => "open ok",
     fail_message => "open failed");
  test.assert
    (check        => close_ok,
     pass_message => "close ok",
     fail_message => "close failed");

end t_init1;

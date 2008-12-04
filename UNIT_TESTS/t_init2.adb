with plexlog;
with test;

procedure t_init2 is
  open_ok  : boolean := true;
  context  : plexlog.plexlog_t;
begin
  begin
    plexlog.open (context, "/nonexistent");
  exception
    when plexlog.open_error => open_ok := false;
  end;

  test.assert
    (check        => open_ok = false,
     pass_message => "open failed, correctly",
     fail_message => "open failed to fail!");

end t_init2;

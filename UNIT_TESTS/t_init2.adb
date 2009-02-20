with Plexlog.API;
with test;

procedure t_init2 is
  open_ok  : boolean := true;
  context  : Plexlog.API.Plexlog_t;
begin
  begin
    Plexlog.API.Open (context, "/nonexistent");
  exception
    when Plexlog.API.Open_Error => open_ok := false;
  end;

  test.assert
    (check        => open_ok = false,
     pass_message => "open failed, correctly",
     fail_message => "open failed to fail!");

end t_init2;

with dir;
with Plexlog.API;
with test;

procedure t_init1 is

  open_ok  : boolean := true;
  close_ok : boolean := true;
  context  : Plexlog.API.Plexlog_t;

begin
  dir.rmdir ("testdata/init");
  dir.mkdir ("testdata/init", 8#0755#);

  begin
    Plexlog.API.Open (context, "testdata/init");
    Plexlog.API.Close (context);
  exception
    when Plexlog.API.Open_Error => open_ok := false;
    when Plexlog.API.Close_Error => close_ok := false;
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

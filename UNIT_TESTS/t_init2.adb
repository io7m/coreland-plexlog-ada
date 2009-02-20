with Plexlog.API;
with test;

procedure t_init2 is
  Open_OK  : Boolean := true;
  Context  : Plexlog.API.Plexlog_t;
begin
  begin
    Plexlog.API.Open (Context, "/nonexistent");
  exception
    when Plexlog.API.Open_Error => Open_OK := false;
  end;

  test.assert
    (check        => Open_OK = false,
     pass_message => "open failed, correctly",
     fail_message => "open failed to fail!");

end t_init2;

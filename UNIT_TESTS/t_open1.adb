with Plexlog.API;
with test;

procedure t_open1 is
  Context : Plexlog.API.Plexlog_t;
  Caught  : Boolean := False;
begin

  begin
    Plexlog.API.Open
      (Context => Context,
       Path    => "/nonexistent");
  exception
    when Plexlog.API.Open_Error => Caught := True;
  end;

  test.assert
    (check        => Caught,
     pass_message => "caught open_error",
     fail_message => "failed to catch open_error");

end t_open1;

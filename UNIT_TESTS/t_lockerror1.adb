-- check FD stack cleanup and lock error.

with Ada.Directories;
with Plexlog.API;
with test;

procedure t_lockerror1 is
  package Directories renames Ada.Directories;

  Caught   : Boolean := False;
  Context  : Plexlog.API.Plexlog_t;
begin

  begin
    Directories.Delete_Tree ("testdata/lockerror");
  exception
    when Directories.Name_Error => null;
  end;
  Directories.Create_Path ("testdata/lockerror");

  Plexlog.API.Open (Context, "testdata/lockerror");
  Directories.Delete_Tree ("testdata/lockerror");

  begin
    Plexlog.API.Write (Context, "failure");
  exception
    when Plexlog.API.Lock_Error => Caught := True;
  end;
  test.assert
    (check        => Caught,
     pass_message => "caught lock_error",
     fail_message => "failed to catch lock_error");

  Plexlog.API.Close (Context);
end t_lockerror1;

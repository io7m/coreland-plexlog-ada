with Ada.Directories;
with Plexlog.API;
with test;

procedure t_init1 is
  package Directories renames Ada.Directories;

  Open_OK  : Boolean := True;
  Close_OK : Boolean := True;
  context  : Plexlog.API.Plexlog_t;

begin
  Directories.Delete_Tree ("testdata/init");
  Directories.Create_Path ("testdata/init");

  begin
    Plexlog.API.Open (context, "testdata/init");
    Plexlog.API.Close (context);
  exception
    when Plexlog.API.Open_Error => Open_OK := False;
    when Plexlog.API.Close_Error => Close_OK := False;
  end;

  test.assert
    (check        => Open_OK,
     pass_message => "open ok",
     fail_message => "open failed");
  test.assert
    (check        => Close_OK,
     pass_message => "close ok",
     fail_message => "close failed");

end t_init1;

with Plexlog.API;
with test;

procedure t_space is
begin

  declare
    Space : constant Plexlog.API.Long_Positive := Plexlog.API.Space_Requirement
      (Max_Files => 1, Max_Size  => 1024);
  begin
    test.assert
      (check        => Space = 2048,
       pass_message => "Space = " & Plexlog.API.Long_Positive'Image (Space),
       fail_message => "Space = " & Plexlog.API.Long_Positive'Image (Space));
  end;

  declare
    Space : constant Plexlog.API.Long_Positive := Plexlog.API.Space_Requirement
      (Max_Files => 10, Max_Size  => 1024);
  begin
    test.assert
      (check        => Space = 11264,
       pass_message => "Space = " & Plexlog.API.Long_Positive'Image (Space),
       fail_message => "Space = " & Plexlog.API.Long_Positive'Image (Space));
  end;

  declare
    Space : constant Plexlog.API.Long_Positive := Plexlog.API.Space_Requirement
      (Max_Files => 100, Max_Size  => 10240);
  begin
    test.assert
      (check        => Space = 1034240,
       pass_message => "Space = " & Plexlog.API.Long_Positive'Image (Space),
       fail_message => "Space = " & Plexlog.API.Long_Positive'Image (Space));
  end;

end t_space;

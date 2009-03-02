with Ada.Text_IO;

package body test is

  procedure sys_exit (ecode : in Integer);
  pragma Import (C, sys_exit, "exit");

  procedure assert
    (check        : in Boolean;
     pass_message : in String := "assertion passed";
     fail_message : in String := "assertion failed") is
  begin
    if check then
      Ada.Text_IO.Put_Line (Ada.Text_IO.Current_Error, "pass: " & pass_message);
    else
      Ada.Text_IO.Put_Line (Ada.Text_IO.Current_Error, "fail: " & fail_message);
      sys_exit (1);
    end if;
  end assert;

end test;

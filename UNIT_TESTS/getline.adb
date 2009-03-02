package body getline is

  procedure get
    (file :  in Ada.Text_IO.File_Type;
     item : out Ada.Strings.Unbounded.Unbounded_String)
  is
    line : String (1 .. 128);
    last : Natural;
  begin
    loop
      Ada.Text_IO.Get_Line
        (File => file,
         Item => line,
         Last => last);
      Ada.Strings.Unbounded.Append
        (Source   => item,
         New_Item => line (1 .. last));
      exit when last < line'Last;
    end loop;
  end get;

end getline;

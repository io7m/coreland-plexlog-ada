with Ada.Text_IO;
with Ada.Strings.Unbounded;

package getline is

  procedure get
    (file :  in Ada.Text_IO.File_Type;
     item : out Ada.Strings.Unbounded.Unbounded_String);

end getline;

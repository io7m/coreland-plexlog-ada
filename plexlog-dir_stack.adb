package body Plexlog.Dir_Stack is

  use type POSIX.FD_t;

  procedure Push_FD
    (Stack : in out Dir_Stack_t;
     FD    : in Plexlog.POSIX.FD_t)
  is
    Current_FD : constant POSIX.FD_t := POSIX.Open_Read (".");
  begin
    -- save current directory
    if Current_FD = POSIX.Invalid_FD then
      raise Push_Error with "could not open current working directory";
    end if;

    -- push current file descriptor onto stack
    if Stack.Index = Stack.FD_Array'Length then
      raise Push_Error with "stack overflow";
    end if;
    Stack.FD_Array (Stack.Index) := Current_FD;
    Stack.Index := Stack.Index + 1;

    -- switch to new directory
    if not POSIX.FD_Change_Directory (FD) then
      Stack.Index := Stack.Index - 1;
      raise Push_Error with "could not change directory";
    end if;
  exception
    when others =>
      POSIX.Close (Current_FD);
      raise;
  end Push_FD;

  procedure Push
    (Stack : in out Dir_Stack_t;
     Path  : in String)
  is
    Path_FD : constant POSIX.FD_t := POSIX.Open_Read (Path);
  begin
    if Path_FD = POSIX.Invalid_FD then
      raise Push_Error with "could not open path";
    end if;

    Push_FD (Stack, Path_FD);
  exception
    when others =>
      POSIX.Close (Path_FD);
      raise;
  end Push;

  procedure Pop
    (Stack : in out Dir_Stack_t)
  is
    Old_FD : constant POSIX.FD_t := Stack.FD_Array (Stack.Index - 1);
  begin
    if not POSIX.FD_Change_Directory (Old_FD) then
      raise Pop_Error with "could not restore directory";
    end if;

    Stack.Index := Stack.Index - 1;

    if not POSIX.Close (Old_FD) then
      raise Pop_Error with "could not close old directory";
    end if;
  end Pop;

  procedure Pop_All
    (Stack : in out Dir_Stack_t)
  is
    Saved_Index : constant FD_Array_Index_t := Stack.Index;
  begin
    if Stack.Index - FD_Array_Index_t'First > 0 then
      for Index in FD_Array_Index_t'First .. Saved_Index loop
        Pop (Stack);
      end loop;
    end if;
  end Pop_All;

  function Size
    (Stack : in Dir_Stack_t) return Natural is
  begin
    return Natural (Stack.Index - FD_Array_Index_t'First);
  end Size;

end Plexlog.Dir_Stack;

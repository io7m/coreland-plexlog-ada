with Plexlog.Dir_Stack;
with test;

procedure t_dir1 is
  Stack : Plexlog.Dir_Stack.Dir_Stack_t;
begin
  test.assert
    (check        => Plexlog.Dir_Stack.Size (Stack) = 0,
     pass_message => "size: " & Natural'Image (Plexlog.Dir_Stack.Size (Stack)),
     fail_message => "size: " & Natural'Image (Plexlog.Dir_Stack.Size (Stack)));

  Plexlog.Dir_Stack.Push
    (Stack => Stack,
     Path  => "testdata");

  test.assert
    (check        => Plexlog.Dir_Stack.Size (Stack) = 1,
     pass_message => "size: " & Natural'Image (Plexlog.Dir_Stack.Size (Stack)),
     fail_message => "size: " & Natural'Image (Plexlog.Dir_Stack.Size (Stack)));

  Plexlog.Dir_Stack.Push
    (Stack => Stack,
     Path  => "init");

  test.assert
    (check        => Plexlog.Dir_Stack.Size (Stack) = 2,
     pass_message => "size: " & Natural'Image (Plexlog.Dir_Stack.Size (Stack)),
     fail_message => "size: " & Natural'Image (Plexlog.Dir_Stack.Size (Stack)));

  Plexlog.Dir_Stack.Pop (Stack);

  test.assert
    (check        => Plexlog.Dir_Stack.Size (Stack) = 1,
     pass_message => "size: " & Natural'Image (Plexlog.Dir_Stack.Size (Stack)),
     fail_message => "size: " & Natural'Image (Plexlog.Dir_Stack.Size (Stack)));

  Plexlog.Dir_Stack.Pop (Stack);

  test.assert
    (check        => Plexlog.Dir_Stack.Size (Stack) = 0,
     pass_message => "size: " & Natural'Image (Plexlog.Dir_Stack.Size (Stack)),
     fail_message => "size: " & Natural'Image (Plexlog.Dir_Stack.Size (Stack)));

  Plexlog.Dir_Stack.Push
    (Stack => Stack,
     Path  => "testdata");

  test.assert
    (check        => Plexlog.Dir_Stack.Size (Stack) = 1,
     pass_message => "size: " & Natural'Image (Plexlog.Dir_Stack.Size (Stack)),
     fail_message => "size: " & Natural'Image (Plexlog.Dir_Stack.Size (Stack)));

  Plexlog.Dir_Stack.Push
    (Stack => Stack,
     Path  => "init");

  test.assert
    (check        => Plexlog.Dir_Stack.Size (Stack) = 2,
     pass_message => "size: " & Natural'Image (Plexlog.Dir_Stack.Size (Stack)),
     fail_message => "size: " & Natural'Image (Plexlog.Dir_Stack.Size (Stack)));

  Plexlog.Dir_Stack.Pop (Stack);

  test.assert
    (check        => Plexlog.Dir_Stack.Size (Stack) = 1,
     pass_message => "size: " & Natural'Image (Plexlog.Dir_Stack.Size (Stack)),
     fail_message => "size: " & Natural'Image (Plexlog.Dir_Stack.Size (Stack)));

  Plexlog.Dir_Stack.Pop (Stack);

  test.assert
    (check        => Plexlog.Dir_Stack.Size (Stack) = 0,
     pass_message => "size: " & Natural'Image (Plexlog.Dir_Stack.Size (Stack)),
     fail_message => "size: " & Natural'Image (Plexlog.Dir_Stack.Size (Stack)));
end t_dir1;

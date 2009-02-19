package dir is

  procedure mkdir
    (name : in string;
     mode : in natural);
  pragma Inline (mkdir);

  procedure rmdir (name : in string);
  pragma Inline (rmdir);

end dir;

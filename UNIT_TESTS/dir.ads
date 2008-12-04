package dir is

  procedure mkdir
    (name : string;
     mode : natural);
  pragma inline (mkdir);

  procedure rmdir (name : string);
  pragma inline (rmdir);

end dir;

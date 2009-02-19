with Interfaces.C.Strings;

package body plexlog is
  package CS renames Interfaces.C.Strings;

  use type C.int;

  package cbinds is
    function open
      (context   : plexlog_t;
       directory : CS.chars_ptr) return C.int;
    pragma Import (C, open, "px_open");

    procedure max_files
      (context : plexlog_t;
       files   : C.unsigned_long);
    pragma Import (C, max_files, "px_max_files");

    procedure max_filesize
      (context : plexlog_t;
       size    : C.unsigned_long);
    pragma Import (C, max_filesize, "px_max_filesize");

    function close (context : plexlog_t) return C.int;
    pragma Import (C, close, "px_close");

    function rotate (context : plexlog_t) return C.int;
    pragma Import (C, rotate, "px_rotate");

    function write
      (context : plexlog_t;
       level   : level_t;
       data    : CS.chars_ptr;
       size    : C.unsigned_long) return C.int;
    pragma Import (C, write, "px_logb");

    function error return CS.chars_ptr;
    pragma Import (C, error, "px_get_error_str");
  end cbinds;

  function error return string is
  begin
    return CS.Value (cbinds.error);
  end error;
  pragma Inline (error);

  procedure open
    (context   : in out plexlog_t;
     directory : string)
  is
    c_dir : aliased C.char_array := C.To_C (directory);
    c_ret : C.int;
  begin
    c_ret := cbinds.open
      (context   => context,
       directory => CS.To_Chars_Ptr (c_dir'Unchecked_Access));
    if c_ret = 0 then
      raise open_error with error;
    end if;
  end open;

  procedure max_files
    (context   : in out plexlog_t;
     max_files : natural) is
  begin
    cbinds.max_files (context, C.unsigned_long (max_files));
  end max_files;

  procedure max_filesize
    (context      : in out plexlog_t;
     max_filesize : natural) is
  begin
    cbinds.max_filesize (context, C.unsigned_long (max_filesize));
  end max_filesize;

  procedure write
    (context : in out plexlog_t;
     level   : level_t;
     data    : string)
  is
    c_data : aliased C.char_array := C.To_C (data);
    c_ret  : C.int;
  begin
    c_ret := cbinds.write
      (context => context,
       level   => level,
       data    => CS.To_Chars_Ptr (c_data'Unchecked_Access),
       size    => c_data'Length);
    if c_ret = 0 then
      raise write_error with error;
    end if;
  end write;

  procedure rotate (context : in out plexlog_t) is
    c_ret : C.int;
  begin
    c_ret := cbinds.rotate (context);
    if c_ret = 0 then
      raise rotate_error with error;
    end if;
  end rotate;

  procedure close (context : in out plexlog_t) is
    c_ret : C.int;
  begin
    c_ret := cbinds.close (context);
    if c_ret = 0 then
      raise close_error with error;
    end if;
  end close;

end plexlog;

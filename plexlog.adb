with interfaces.c.strings;

package body plexlog is
  package cs renames interfaces.c.strings;

  use type c.int;

  package cbinds is
    function open
      (context   : plexlog_t;
       directory : cs.chars_ptr) return c.int;
    pragma import (c, open, "px_open");

    procedure max_files
      (context : plexlog_t;
       files   : c.unsigned_long);
    pragma import (c, max_files, "px_max_files");

    procedure max_filesize
      (context : plexlog_t;
       size    : c.unsigned_long);
    pragma import (c, max_filesize, "px_max_filesize");

    function close (context : plexlog_t) return c.int;
    pragma import (c, close, "px_close");
 
    function rotate (context : plexlog_t) return c.int;
    pragma import (c, rotate, "px_rotate");
 
    function write
      (context : plexlog_t;
       level   : level_t;
       data    : cs.chars_ptr;
       size    : c.unsigned_long) return c.int;
    pragma import (c, write, "px_logb");

    function error return cs.chars_ptr;
    pragma import (c, error, "px_get_error_str");
  end cbinds;

  function error return string is
  begin
    return cs.value (cbinds.error);
  end error;
  pragma inline (error);

  procedure open
    (context   : in out plexlog_t;
     directory : string)
  is
    c_dir : aliased c.char_array := c.to_c (directory);
    c_ret : c.int;
  begin
    c_ret := cbinds.open
      (context   => context,
       directory => cs.to_chars_ptr (c_dir'unchecked_access));
    if c_ret = 0 then
      raise open_error with error;
    end if;
  end open;

  procedure max_files
    (context   : in out plexlog_t;
     max_files : natural) is
  begin
    cbinds.max_files (context, c.unsigned_long (max_files));
  end max_files;

  procedure max_filesize
    (context      : in out plexlog_t;
     max_filesize : natural) is
  begin
    cbinds.max_filesize (context, c.unsigned_long (max_filesize));
  end max_filesize;

  procedure write
    (context : in out plexlog_t;
     level   : level_t;
     data    : string)
  is
    c_data : aliased c.char_array := c.to_c (data);
    c_ret  : c.int;
  begin
    c_ret := cbinds.write
      (context => context,
       level   => level,
       data    => cs.to_chars_ptr (c_data'unchecked_access),
       size    => c_data'length);
    if c_ret = 0 then
      raise write_error with error;
    end if;
  end write;

  procedure rotate (context : in out plexlog_t) is
    c_ret : c.int;
  begin
    c_ret := cbinds.rotate (context);
    if c_ret = 0 then
      raise rotate_error with error;
    end if;
  end rotate;

  procedure close (context : in out plexlog_t) is
    c_ret : c.int;
  begin
    c_ret := cbinds.close (context);
    if c_ret = 0 then
      raise close_error with error;
    end if;
  end close;

end plexlog;

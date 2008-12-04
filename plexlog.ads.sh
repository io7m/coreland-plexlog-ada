#!/bin/sh

die()
{
  echo "fatal: $1" 1>&2
  exit 112
}

main_size=`./chk-size`
if [ $? -ne 0 ]
then
  die "could not get structure size"
fi

cat <<EOF
with interfaces.c;

package plexlog is

  type level_t is
    (LOG_NONE,
     LOG_DEBUG,
     LOG_INFO,
     LOG_NOTICE,
     LOG_WARN,
     LOG_ERROR,
     LOG_FATAL);
   for level_t use
    (LOG_NONE   => 0,
     LOG_DEBUG  => 1,
     LOG_INFO   => 2,
     LOG_NOTICE => 3,
     LOG_WARN   => 4,
     LOG_ERROR  => 5,
     LOG_FATAL  => 6);

  -- generated by make-types
`./make-types`

  type plexlog_t is limited private;

  open_error   : exception;
  write_error  : exception;
  close_error  : exception;
  rotate_error : exception;

  procedure open
    (context   : in out plexlog_t;
     directory : string);
  pragma inline (open);

  procedure max_files
    (context   : in out plexlog_t;
     max_files : natural);
  pragma inline (max_files);

  procedure max_filesize
    (context      : in out plexlog_t;
     max_filesize : natural);
  pragma inline (max_filesize);

  procedure write
    (context : in out plexlog_t;
     level   : level_t;
     data    : string);
  pragma inline (write);

  procedure rotate
    (context : in out plexlog_t);
  pragma inline (rotate);

  procedure close
    (context : in out plexlog_t);
  pragma inline (close);

private
  package c renames interfaces.c;

  -- sizeof (struct plexlog) == ${main_size}
  type plexlog_t is array (1 .. ${main_size}) of aliased c.char;
  pragma convention (c, plexlog_t);

end plexlog;
EOF

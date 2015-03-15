#
# Logging
#

define syslog_ng::log (
  $source          = $::syslog_ng::local_source,
  $filter          = undef,
  $filter_spec     = undef,
  $parser          = undef,
  $rewrite         = undef,
  $destination     = undef,
  $file            = undef,
  $fallback        = undef,
  $owner           = undef,
  $group           = undef,
  $dir_owner       = undef,
  $dir_group       = undef,
  $perm            = undef,
  ) {
  validate_string($source)
  if $fallback {
    $target = $::syslog_ng::config_file_fallback
  }
  else {
    $target = $::syslog_ng::config_file_logging
  }
  if $file {
    syslog_ng::destination::file {"d_${name}":
      file      => $file,
      owner     => $owner,
      group     => $group,
      dir_owner => $dir_owner,
      dir_group => $dir_group,
      perm      => $perm
    }
  }
  if $filter_spec {
    syslog_ng::filter {"f_${name}":
      spec => $filter_spec
    }
  }
  concat::fragment{ "${name}_log":
    target  => $target,
    content => template('syslog_ng/log.erb'),
  }
}
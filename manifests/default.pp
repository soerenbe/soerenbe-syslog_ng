define syslog_ng::default (
  $source    = undef,
  $directory = $::syslog_ng::system_log_dir,
  $host      = undef,
  $owner     = undef,
  $group     = undef,
  $dir_owner = undef,
  $dir_group = undef,
  $perm      = undef,
  ) {
  validate_string($source)
  validate_absolute_path($directory)
  if $host {
    $f = "${::syslog_ng::config_dir}/70block_default_remote_${name}.conf"
  }
  else {
    $f = "${::syslog_ng::config_dir}/15block_default_${name}.conf"
  }
  file { "$f":
    content => template('syslog_ng/default.conf.erb'),
    notify  => Service[syslog_ng],
  }
}
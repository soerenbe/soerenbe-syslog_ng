#
# rewrite
#
define syslog_ng::rewrite (
  $spec   = undef,
  $target = $::syslog_ng::config_file_rewrite,
  ) {
  $entry_type = 'rewrite'
  concat::fragment{ $name:
    target  => $target,
    content => template('syslog_ng/entry.erb')
  }
}
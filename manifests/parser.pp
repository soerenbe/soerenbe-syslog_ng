# parser keyword
define syslog_ng::parser (
  $spec   = undef,
  $target = $::syslog_ng::config_file_parser,
  ) {
  $entry_type = 'parser'
  concat::fragment{ $name:
    target  => $target,
    content => template('syslog_ng/entry.erb')
  }
}

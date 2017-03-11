# Generic syslog destination
define syslog_ng::destination (
  $spec   = undef,
  $target = $::syslog_ng::config_file_destination_files,
  ) {
  validate_string($target)
  $entry_type = 'destination'
  concat::fragment{ "destination_${name}":
    target  => $target,
    content => template('syslog_ng/entry.erb')
  }
}

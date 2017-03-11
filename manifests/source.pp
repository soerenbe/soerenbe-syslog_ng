# Generic syslog_ng source
define syslog_ng::source (
  $spec     = undef,
  $fallback = undef,
) {
  $entry_type = 'source'
  concat::fragment{ $name:
    target  => $::syslog_ng::config_file_sources,
    content => template('syslog_ng/entry.erb')
  }
  if $fallback {
    validate_string($fallback)
    syslog_ng::destination::file {"${name}_fallback":
      file   => $fallback,
      target => $::syslog_ng::config_file_destination_fallback,
    }
    $source      = $name
    $destination = "${name}_fallback"
    concat::fragment{ "${name}_fallback":
      target  => $::syslog_ng::config_file_fallback,
      content => template('syslog_ng/log.erb')
    }
  }
}


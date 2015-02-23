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

# syslog-ng network source
define syslog_ng::source::network(
  $ip       = undef,
  $port     = undef,
  $proto    = 'udp',
  $fallback = undef,
  ) {
  case $proto {
    'UDP', 'udp': {
      syslog_ng::source { $name:
        spec     => "udp(ip('${ip}') port(${port}));",
        fallback => $fallback
      }
    }
    'TCP', 'tcp': {
      syslog_ng::source { $name:
        spec     => "tcp(ip('${ip}') port(${port}));",
        fallback => $fallback
      }
    }
    'ALL', 'all': {
      syslog_ng::source { $name:
        spec     => "\n  tcp(ip('${ip}') port(${port}));\n  udp(ip('${ip}') port(${port}));\n",
        fallback => $fallback
      }
    }
    default: {
      fail("${proto} is not supported by syslog_ng::server")
    }
  }
}

# syslog-ng default system source
define syslog_ng::source::system {
    syslog_ng::source {$name:
      spec  => 'system(); internal();',
    }
}

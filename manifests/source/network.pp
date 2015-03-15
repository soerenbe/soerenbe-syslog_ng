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
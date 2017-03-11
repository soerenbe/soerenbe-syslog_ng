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
    'UDP6', 'udp6': {
      syslog_ng::source { $name:
        spec     => "udp6(ip('${ip}') port(${port}));",
        fallback => $fallback
      }
    }
    'TCP', 'tcp': {
      syslog_ng::source { $name:
        spec     => "tcp(ip('${ip}') port(${port}));",
        fallback => $fallback
      }
    }
    'TCP6', 'tcp6': {
      syslog_ng::source { $name:
        spec     => "tcp6(ip('${ip}') port(${port}));",
        fallback => $fallback
      }
    }
    'ALL', 'all': {
      syslog_ng::source { $name:
        spec     => "\n  tcp(ip('${ip}') port(${port}));\n  udp(ip('${ip}') port(${port}));\n",
        fallback => $fallback
      }
    }
    'ALL6', 'all6': {
      syslog_ng::source { $name:
        spec     => "\n  tcp6(ip('${ip}') port(${port}));\n  udp6(ip('${ip}') port(${port}));\n",
        fallback => $fallback
      }
    }
    default: {
      fail("${proto} is not supported by syslog_ng::server")
    }
  }
}
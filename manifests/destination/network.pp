# syslog network destination
define syslog_ng::destination::network (
  $log_server = undef,
  $log_port   = undef,
  $proto      = 'udp',
  ) {
  case $proto {
    'UDP', 'udp': {
      syslog_ng::destination {$name:
        spec   => "udp('${log_server}' port(${log_port}) log_fifo_size(${::syslog_ng::log_fifo_size_destination}));",
        target => $syslog_ng::params::config_file_destination_remote
      }
    }
    'TCP', 'tcp': {
      syslog_ng::destination {$name:
        spec   => "tcp('${log_server}' port(${log_port}) log_fifo_size(${::syslog_ng::log_fifo_size_destination}));",
        target => $syslog_ng::params::config_file_destination_remote
      }
    }
    default: {
      fail("${proto} is not supported by syslog_ng::client")
    }
  }
}

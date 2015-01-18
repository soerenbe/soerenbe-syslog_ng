class syslog_ng::client (
  $log_server = undef,
  $log_port   = undef,
  $proto      = "udp",
  ) {
  include syslog_ng
  case $proto {
    'UDP', 'udp': {
      syslog_ng::destination::udpclient {'d_auto_logsrv':
        ip   => $log_server,
        port => $log_port,
      }
    }
    'TCP', 'tcp': {
      syslog_ng::destination::tcpclient {'d_auto_logsrv':
        ip   => $log_server,
        port => $log_port,
      }
    }
    default: {
      fail("$proto is not supported by syslog_ng::client")
    }
  }
  syslog_ng::log{"logtarget_auto_logsrv": source => "s_src", destination => "d_auto_logsrv"}
}
  

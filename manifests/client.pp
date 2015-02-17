class syslog_ng::client (
  $log_server = undef,
  $log_port   = undef,
  $proto      = "udp",
  ) {
  include syslog_ng
  syslog_ng::destination::network {'d_auto_logsrv':
    log_server => $log_server,
    log_port   => $log_port,
    proto      => $proto,
  }
  syslog_ng::log{"logtarget_auto_logsrv": source => $::syslog_ng::local_source, destination => "d_auto_logsrv"}
}
  

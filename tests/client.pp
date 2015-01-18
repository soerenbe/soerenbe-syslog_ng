include syslog_ng
syslog_ng::destination::udpclient { 'd_log-analyse':
  ip   => '192.168.10.102',
  port => '514'
}
syslog_ng::destination::tcpclient { 'd_tcp_log-analyse':
  ip   => '192.168.10.103',
  port => '514'
}
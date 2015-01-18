class syslog_ng::service {
  service { 'syslog_ng':
    name       => "syslog-ng",
    ensure     => 'running',
    hasstatus  => true,
    hasrestart => true,
    require    => Package['syslog-ng'],
  }
  # TODO "syslog-ng -s" macht ein configcheck. Das sollte erst gecheckt werden.
}
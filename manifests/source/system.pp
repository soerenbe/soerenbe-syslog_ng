# syslog-ng default system source
define syslog_ng::source::system {
    syslog_ng::source {$name:
      spec  => 'system(); internal();',
    }
}
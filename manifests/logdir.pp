# Adds a logdir that is managed by the module
define syslog_ng::logdir (
  $owner         = $::syslog_ng::default_owner,
  $group         = $::syslog_ng::default_group,
) {
  file {$name:
    ensure => directory,
    owner  => $owner,
    group  => $group,
  }
  if $::syslog_ng::reminder_file {
    file {"${name}/${::syslog_ng::reminder_file}":
      ensure  => file,
      owner   => $owner,
      group   => $group,
      content => "# MANAGED BY PUPPET\n",
    }
  }
}
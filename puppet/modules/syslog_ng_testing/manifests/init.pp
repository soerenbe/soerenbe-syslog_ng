# This is a helper modul to illustrate the syslog_ng package
# It will install a log generator script to the vagrant virtual machines
class syslog_ng_testing (
  $config_file = undef
) {
  file {'/etc/loggen.conf':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source  => "puppet:///modules/syslog_ng_testing/$config_file",
  }
  file {'/usr/local/bin/loggen.py':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source  => "puppet:///modules/syslog_ng_testing/loggen.py",
  }
}
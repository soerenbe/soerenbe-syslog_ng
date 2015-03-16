# Install a block file into syslog-ng config directory
define syslog_ng::block::install (
    $source = undef,
  ) {
  file {"/etc/syslog-ng/conf.d/00block_${name}.conf":
    ensure => present,
    source => $source
  }
}
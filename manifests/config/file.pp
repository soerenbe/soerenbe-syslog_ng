# Add a complete config file
# This can be used for example for custom blocks
define syslog_ng::config::file (
  $source,
  $config_dir      = $::syslog_ng::params::config_dir,
  $config_priority = '15',
) {
  file {"${config_dir}/${config_priority}${name}.conf":
    source => $source
  }
}
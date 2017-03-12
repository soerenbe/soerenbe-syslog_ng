# Add a complete config file
# This can be used for example for custom blocks
define syslog_ng::config::template (
  $template,
  $config_dir      = $::syslog_ng::params::config_dir,
  $config_priority = '15',
  $config          = {},
) {
  validate_hash($config)
  file {"${config_dir}/${config_priority}${name}.conf":
    content => template($template)
  }
}
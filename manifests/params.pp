# Standard parameters for the modul
class syslog_ng::params {
  if $::lsbdistcodename == 'stretch' {
    $version        = '3.8'
  }
  else {
    $version        = '3.5'
  }
  $system_log_dir = '/var/log'
  $config_dir     = '/etc/syslog-ng/conf.d'
  $local_source   = 's_src'
  $reminder_file  = undef

  # Default global settings for syslog-ng
  # See: http://www.balabit.com/sites/default/files/documents/syslog-ng-ose-3.5-guides/en/syslog-ng-ose-guide-admin/html/index.html
  # See: http://www.balabit.com/sites/default/files/documents/syslog-ng-ose-3.5-guides/en/syslog-ng-ose-guide-admin/html/reference-options.html
  #
  # Global permissions
  $create_dirs               = true   # If true, all subdirectories are created. TODO: Maybe define for each file?
  $default_owner             = 'root'
  $default_group             = 'adm'
  $default_perm              = '0640'
  # DNS behaviour
  $use_fqdn                  = 'no'
  $use_dns                   = 'yes'
  $chain_hostnames           = 'no'
  $keep_hostname             = 'no'
  # Logfile behaviour
  $stats_freq                = 0
  $mark_freq                 = 0
  # Performance tweaks
  $threaded                  = 'no'
  $flush_lines               = 0
  $log_fifo_size             = '10000'
  # default is 10000, this is far to much. This should be enough for outgoing destinations
  $log_fifo_size_destination = '1000'

  # Config file fragments
  $config_file_sources              = "${config_dir}/10sources.conf"
  $config_file_destination_files    = "${config_dir}/20destination_files.conf"
  $config_file_destination_fallback = "${config_dir}/20destination_fallback.conf"
  $config_file_destination_remote   = "${config_dir}/20destination_remote.conf"
  $config_file_filter               = "${config_dir}/30filter.conf"
  $config_file_parser               = "${config_dir}/40parser.conf"
  $config_file_rewrite              = "${config_dir}/50rewrite.conf"
  $config_file_blocks               = "${config_dir}/80blocks.conf"
  $config_file_logging              = "${config_dir}/90logging.conf"
  $config_file_fallback             = "${config_dir}/99fallback.conf"
}

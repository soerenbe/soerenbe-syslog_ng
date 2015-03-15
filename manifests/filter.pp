#
# Filters
#

define syslog_ng::filter (
  $spec = undef,
  ) {
  $entry_type = 'filter'
  concat::fragment{ "${name}_fallback":
    target  => $::syslog_ng::config_file_filter,
    content => template('syslog_ng/entry.erb')
  }
}
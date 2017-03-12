# Instantiate a block.
# The block implementation currently can not be done by this module
# You may want to use syslog::config::file to upload a block implementation
define syslog_ng::block(
  $block_name,
  $block_config = {},
  $target       = $::syslog_ng::config_file_blocks,
  ) {
  validate_hash($block_config)
  concat::fragment{ $name:
    target  => $target,
    content => template('syslog_ng/block.erb')
  }
}
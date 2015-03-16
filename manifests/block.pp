# instanciate a block
define syslog_ng::block (
  $block_name = undef,
  $params     = undef,
  ){
concat::fragment{ $name:
    target  => $::syslog_ng::config_file_block,
    content => template('syslog_ng/block.conf.erb')
  }
}
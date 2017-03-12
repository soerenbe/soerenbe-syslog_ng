node 'default' {
  include syslog_ng
  syslog_ng::config::file {'custom':
    source      => 'puppet:///modules/filesource/custom_block.conf';
  }
  syslog_ng::config::template {'template':
    template => 'filesource/custom_template.erb',
    config   => {
      hallo   => '',
      ip      => '192.168.10.10',
      comment => '# This is a comment in a hash'
    },
  }
  syslog_ng::block{'my_block_instance':
    block_name   => 'test_block',
    block_config => {
      'host'      => 'www.google.de',
      'directory' => '/var/log/google.de',
      'net'       => '192.168.0.0/255.255.255.0',
    }
  }
}

node 'logserver' {
  include syslog_ng
  # First make sure all log directories are created
  syslog_ng::logdir{'/var/log/myapp': }
  syslog_ng::logdir{'/var/log/myapp/apps': }
  # Define the general log server where the apps will log their messages
  syslog_ng::source::network {'s_network':
    ip    => '10.0.3.100',
    port  => '514',
    proto => 'tcp',
  }
  # Install a predefined block
  syslog_ng::block::install {'myapp':
    source => 'puppet:///modules/syslog_ng_testing/myapp.conf'
  }
  syslog_ng::block{'myapp_general':
    block_name => 'myapp',
    params     => {
      'source' => 's_network',
    },
  }
  # instanciate a block for 3 different apps
  syslog_ng::block{'myapp_app_import':
    block_name => 'myapp_app',
    params     => {
      'source' => 's_network',
      'app'    => 'import'
    },
  }
  syslog_ng::block{'myapp_app_fun':
    block_name => 'myapp_app',
    params     => {
      'source' => 's_network',
      'app'    => 'fun'
    },
  }
  syslog_ng::block{'myapp_app_django':
    block_name => 'myapp_app',
    params     => {
      'source' => 's_network',
      'app'    => 'django'
    },
  }
  # In addition add another port. logclient_1 will log everything there
  syslog_ng::source::network {'s_network2':
    ip    => '10.0.3.100',
    port  => '5514',
    proto => 'tcp',
  }
  # Add a file to the second logserver port
  syslog_ng::log {'l_logclient1':
    source => 's_network2',
    file   => '/var/log/logclient1.log'
  }
}

node 'logclient_1' {
  include syslog_ng
  # Define the logtarget for the app
  syslog_ng::destination::network { 'd_network':
    log_server => '10.0.3.100',
    log_port   => '514',
    proto      => 'tcp',
  }
  # Define to logtarget for the other logs
  syslog_ng::destination::network { 'd_network2':
    log_server => '10.0.3.100',
    log_port   => '5514',
    proto      => 'tcp',
  }
  # log everything from the app to the network
  syslog_ng::log { 'log_all_network':
    source      => 's_src',
    filter_spec => 'program(myapp.*)',
    destination => 'd_network',
  }
  # log everything else to the other port.
  syslog_ng::log { 'log_all_network2':
    source      => 's_src',
    filter_spec => 'not program(myapp.*)',
    destination => 'd_network2',
  }
  # the loggen.py script and config file
  # log into the machine and call 'loggen.py' to start logging to the server
  class { 'syslog_ng_testing':
    config_file => 'logclient_1.conf'
  }
}

node 'logclient_2' {
  include syslog_ng
  syslog_ng::destination::network {'d_network':
    log_server => '10.0.3.100',
    log_port   => '514',
    proto      => 'tcp',
  }
  syslog_ng::log {'log_all_network':
    source      => 's_src',
    filter_spec => 'program(myapp.*)',
    destination => 'd_network',
  }

  class { 'syslog_ng_testing':
    config_file => 'logclient_2.conf'
  }
}

node 'logclient_3' {
  include syslog_ng
  syslog_ng::destination::network {'d_network':
    log_server => '10.0.3.100',
    log_port   => '514',
    proto      => 'tcp',
  }
  syslog_ng::log {'log_all_network':
    source      => 's_src',
    filter_spec => 'program(myapp.*)',
    destination => 'd_network',
  }

  class { 'syslog_ng_testing':
    config_file => 'logclient_3.conf'
  }
}
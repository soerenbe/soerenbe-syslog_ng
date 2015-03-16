# syslog_ng

#### Table of Contents

1. [Overview](#overview)
3. [Setup](#setup)
    * [What syslog_ng affects](#what-syslog_ng-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with syslog_ng](#beginning-with-syslog_ng)
4. [Usage](#usage)
    * [Custom logging](#custom-logging)
    * [Log server](#log-server)
    * [Log client](#log-client)
5. [Classes and Defined Types](#classes-and-defined-types)
    * [Class: syslog_ng](#class-syslog_ng)
    * [Defined Type: syslog_ng::source](#defined-source)
    * [Defined Type: syslog_ng::source::network](#defined-source-network)
    * [Defined Type: syslog_ng::destination](#defined-destination)
    * [Defined Type: syslog_ng::destination::file](#defined-destination-file)
    * [Defined Type: syslog_ng::destination::network](#defined-destination-network)
    * [Defined Type: syslog_ng::filter](#defined-filter)
    * [Defined Type: syslog_ng::log](#defined-log)
    * [Defined Type: syslog_ng::default](#defined-default)
    * [Defined Type: syslog_ng::logdir](#defined-logdir)

5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)


## Overview

This is a puppet syslog_ng module. On basic settings it simply installs the syslog-ng deamon. You can configure the module to setup complex client/server logserver server setups. It is heavily tested under Ubuntu 14.04, but through the nature of syslog-ng at least Debian and other Ubuntu versions should work fine.

## Setup

### What syslog_ng affects

Mainly this module manages all file in `/etc/syslog-ng`. It creates a basic `/etc/syslog/syslog-ng.conf` and include configuration fragments in `/etc/syslog-ng/conf.d`.

WARNING: Typically syslog-ng replaces the current (and default) syslog deamon. This means it will uninstall `rsyslogd`!

### Setup Requirements

`syslog_ng` requires `puppetlabs-stdlib` and `puppetlabs-concat`

### Beginning with syslog_ng

```puppet
    include syslog_ng
```

This will install the basic `syslog-ng` deamon. It should behave like a normal installation with default config file.

## Usage

Beside the basic configuration the module gives a abstraction to the typical syslog-ng concepts of *source*, *destination*, *filter* and *log*

In addition the module provides some basic resources for typical application scenarios like a log server, log client or "Log the application xyz to file".    

### Custom logging

You can use the resources to build custom log rules. The basic system log source is defined in `syslog_ng::params::local_source`. By default it is set to the package default `s_src`. You can use this source in your custom log rules. The following example uses the standard syslog-ng config and logs all messages of the program `puppet-agent` to its own log file `/var/log/puppet.log`

```
    include syslog_ng
    puppet
    syslog_ng::destination::file { 'puppet_log_file':
      file => '/var/log/puppet.log'
    }
    syslog_ng::filter {'puppet_agent':
      spec => 'program("puppet-agent")'
    }
    syslog_ng::log { 'puppet_agent':
      source      => 's_src',
      filter      => 'puppet_agent',
      destination => 'puppet_log_file'
    } 
```
You may provide also provide a list for `filter` or `destination`

In most cases (like above) you simply want to generate a filter, apply it to a source and log this to a new log file. For this the `syslog_ng::log` resource provides a shortcut. You may define the example above like:

```puppet
    include syslog_ng
    syslog_ng::log { 'puppet_agent':
      source      => 's_src',
      filter_spec => 'program("puppet-agent")',
      file        => '/var/log/puppet.log'
    } 
```

### Log server

If you want your syslog-ng installation to act like a log server you can use define them completly free by using `syslog_ng::source` resource. You may find a detailed description below. In most cases you want to use the predefined server resources.

```puppet
    include syslog_ng
    syslog_ng::udpserver {'udp_source_514':
        ip   => '0.0.0.0',
        port => '514'
    }
    syslog_ng::source::network {'tcp_source_5514':
        ip    => '0.0.0.0',
        port  => '5514',
        proto => 'tcp'
    }
```     

### Log client

If you want your syslog-ng deamon to log to a remote location you have to define a remote `destination` resource and use it in your `syslog_ng::log`` resource.
The following example logs all puppet-agent logs to the remote log server defined above.

```puppet
    include syslog_ng
    syslog_ng::destination::network {'logserver': 
        log_server => '192.168.122.10',
        log_port => '514'
    } 
    syslog_ng::log { 'puppet_agent':
      source      => 's_src',
      filter_spec => 'program("puppet-agent")',
      destination => 'logserver'
    }
```

## Classes and Defined Types

Many resource type use following parameters. The will not be mentioned in the detailed description:
```puppet
    $owner     = undef,
    $group     = undef,
    $dir_owner = undef,
    $dir_group = undef,
    $perm      = undef,
```
If they are not set the, the file/directory permission are managed by syslog-ng and will be set to the defaults defined in the syslog-ng module class.
### Class: syslog_ng
This is the main class for the syslog-ng installation. See `syslog_ng::params` for a the detailed defaults.

```puppet
    class syslog_ng (
      $system_log_dir            = $syslog_ng::params::system_log_dir,             # This is the default log directory
      $config_dir                = $syslog_ng::params::config_dir,                 # This is the default config directory
      $local_source              = $syslog_ng::params::local_source,               # This source is used for the local logging source.
      $reminder_file             = $syslog_ng::params::reminder_file,              # Reminder file name (see syslog_ng::logdir)
      $create_dirs               = $syslog_ng::params::create_dirs,                # If this is set to 'true' syslog-ng will create all required directories for a log file.
      $default_owner             = $syslog_ng::params::default_owner,              # global default for syslog-ng
      $default_group             = $syslog_ng::params::default_group,              # global default for syslog-ng
      $default_perm              = $syslog_ng::params::default_perm,               # global default for syslog-ng
      $use_fqdn                  = $syslog_ng::params::use_fqdn,                   # syslog-ng config parameter
      $use_dns                   = $syslog_ng::params::use_dns,                    # syslog-ng config parameter
      $chain_hostnames           = $syslog_ng::params::chain_hostnames,            # syslog-ng config parameter
      $stats_freq                = $syslog_ng::params::stats_freq,                 # syslog-ng config parameter
      $mark_freq                 = $syslog_ng::params::mark_freq,                  # syslog-ng config parameter
      $threaded                  = $syslog_ng::params::threaded,                   # syslog-ng config parameter
      $flush_lines               = $syslog_ng::params::flush_lines,                # syslog-ng config parameter
      $log_fifo_size             = $syslog_ng::params::log_fifo_size,              # syslog-ng config parameter
      $log_fifo_size_destination = $syslog_ng::params::log_fifo_size_destination,  # syslog-ng config parameter
    )
```

### Defined Type: syslog_ng::source
This is a general source resource type. In most cases you want to use `syslog_ng::source::network` or the predefined and already existing source `s_src`

```puppet
define syslog_ng::source (
  $spec     = undef,         # specification of the source
  $fallback = undef,         # use the fallback tag
  )
```

### Defined Type: syslog_ng::source::network
This type defines a network source. It is typically used on a log server.

```puppet
    define syslog_ng::source::network(
      $ip       = undef,               # The IP Adress of the remote source
      $port     = undef,               # The port of the remote source
      $proto    = "udp",               # The protocol to use. Only 'udp','tcp' or 'all' is supported
      $fallback = undef,               # The fallback file
    )
```

### Defined Type: syslog_ng::destination
This type defines a destination within syslog_ng. Typically you want to use `syslog_ng::destination::file` or `syslog_ng::destination::network`.

```puppet
    define syslog_ng::destination (
      $spec   = undef,               # specification of the destination
    )
```
### Defined Type: syslog_ng::destination::file
This type defines a log file as a destination.

```puppet
    define syslog_ng::destination::file (
      $file      = undef,                  # the file name of the destination
      $owner     = undef,
      $group     = undef,
      $dir_owner = undef,
      $dir_group = undef,
      $perm      = undef,
    )
```
### Defined Type: syslog_ng::destination::network
This type defines a remote host as a destination. Typically this is used by a log client to log to a remote server.

```puppet
    define syslog_ng::destination::network (
      $log_server = undef,               # The IP Adress of the remote source
      $log_port = undef,               # The port of the remote source
      $proto    = "udp",               # The protocol to use. Only 'udp' and 'tcp' is supported
    )
```
### Defined Type: syslog_ng::filter
This type defines a syslog-ng filter. You may use any filter syntax syslog-ng provides.

```puppet
    define syslog_ng::filter (
      $spec = undef,           # specification of the filter
      )
```

### Defined Type: syslog_ng::rewrite
This type defines a syslog-ng rewrite. You may use any filter syntax syslog-ng provides.
```puppet
    define syslog_ng::rewrite (
      $spec = undef,           # specification of the rewrite
      )
```

### Defined Type: syslog_ng::parser
This type defines a syslog-ng parser. You may use any filter syntax syslog-ng provides.
```puppet
    define syslog_ng::parser (
      $spec = undef,           # specification of the parser
      )
```

Examples:
```puppet
    syslog_ng::filter {'host_filter':    spec => 'host("webserver")' }
    syslog_ng::filter {'program_filter': spec => 'program("puppet-agent")' }
    syslog_ng::filter {'nodebug_apache': spec => 'program("apache2") and level(info..emerg)' }
```
### Defined Type: syslog_ng::log
This type defines the general log behaviour. It used defined sources, filter and destination and combine them to a logging rule.

```puppet
    define syslog_ng::log (
      $source          = undef,   # The source to log from
      $filter          = undef,   # The filter to apply (can be a list)
      $filter_spec     = undef,   # The new filter to apply
      $destination     = undef,   # The destination to log to
      $file            = undef,   # The logfile to log to
      $fallback        = undef,   # evaluate the syslog-ng fallback flag
      $owner           = undef,   # This applies to $file
      $group           = undef,   # This applies to $file
      $dir_owner       = undef,   # This applies to $file
      $dir_group       = undef,   # This applies to $file
      $perm            = undef,   # This applies to $file
    )
```

Examples that logs everything that is more or equal than an 'error' to the remote log server and to a file:
```puppet
    syslog_ng::log {'remote_error':
        source => 's_src',
        filter_spec => 'level(error..emerg)',
        destination => 'logserver',
        file        => '/var/log/private_errors'       
    }
```

### Defined Type: syslog_ng::block::install
This type defines a additional block source file. Sometimes you already have a sophisticated block for your application. You can reuse it here.

```puppet
    define syslog_ng::block::install (
      $source = undef       # The source of the block file       
    )
```

Note that you can use any puppet source. You may want to place the block files on your fileserver or a seperate puppet module.

### Defined Type: syslog_ng::block
This type defines a instance of a block defined with `syslog_ng::block::install`.

```puppet
    define syslog_ng::block (
      $block_name = undef,     # The name of the block (see syslog_ng::block::install)
      $params     = undef,     # parameter hash for the block
    )
```

Example:
```puppet
    syslog_ng::block{'myapp_app_fun':
        block_name => 'myapp_app',
        params     => {
            'source' => 's_network',
            'app'    => 'fun'
        },
    }
```


### Defined Type: syslog_ng::default
This type is typically used to create the default syslog-ng configuration. You may use it on your own for completely logging a remote server to a log server without completly define all filters, files and log entries. Note that a normal setup will fill the `$directory` with a log of different files.

```puppet
    define syslog_ng::default (
      $source    = undef,                           # the source to log from
      $directory = $::syslog_ng::system_log_dir,    # The directory to log from
      $host      = undef,                           # The host which should be filtered
      $owner     = undef,
      $group     = undef,
      $dir_owner = undef,
      $dir_group = undef,
      $perm      = undef,
    )
```
Example:

```puppet
    syslog_ng::source::network {'log_server':
      ip   => '0.0.0.0'
      port => '514'
    }
    syslog_ng::logdir {'/var/log/hosts/webserver'}
    syslog_ng::defaut { 'from_webserver':
      source    => 'log_server',
      host      => 'webserver.mydomain.com',
      directory => '/var/log/hosts/webserver',
    }

```

### Defined Type: syslog_ng::logdir
This type may define some log dirs which will be generated. syslog_ng::reminder_file is set, it will place this file in this directory. It also ensures that the directory is generated and have the correct permissions.



## Reference

* syslog-ng administation guide [Link](http://www.balabit.com/sites/default/files/documents/syslog-ng-ose-3.5-guides/en/syslog-ng-ose-guide-admin/html/index.html)
* syslog-ng reference options [Link](http://www.balabit.com/sites/default/files/documents/syslog-ng-ose-3.5-guides/en/syslog-ng-ose-guide-admin/html/reference-options.html)
* Since your log files may run out of control have a look at [rodjek/logrotate](https://forge.puppetlabs.com/rodjek/logrotate)
  
## Limitations

This module heavily tested under Ubuntu 14.04, but through the nature of syslog-ng at least Debian and other Ubuntu versions should work fine.

The module does not cover all features by syslog-ng. Some examples:

* message flags that are not the fallback flags
* message templates

Further releases may add some features depending on the developers motivation/requirements or community feedback.

## Development

If you have any bugfixes, enhancements that should be included in this module feel free to send me a pull request.


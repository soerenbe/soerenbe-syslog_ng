syslog_ng::filter {'test_filter':
  spec => 'host("test-machine")'
}

$source="mysource"
$directory="/var/log/test"
$filter="test_filter"
$group="root"

include syslog_ng

syslog_ng::block::zarafa {"zarafa_${name}":
  source    => $source,
  filter    => $filter,
  directory => $directory,
  group     => $group,
}
syslog_ng::block::advanced {"mailrelay_${name}":
  source    => $source,
  filter    => $filter,
  directory => "${directory}/system",
  group     => $group,
}
syslog_ng::block::apache2 {"zarafa_${name}":
  source    => $source,
  filter    => $filter,
  directory => "${directory}/apache2",
  group     => $group,
}
syslog_ng::block::advanced {"zarafa_system_${name}":
  source    => $source,
  filter    => $filter,
  directory => "${directory}/system",
  group     => $group,
}
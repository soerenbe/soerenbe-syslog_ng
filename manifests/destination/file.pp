# syslog file destination
define syslog_ng::destination::file (
    $file      = undef,
    $owner     = undef,
    $group     = undef,
    $dir_owner = undef,
    $dir_group = undef,
    $perm      = undef,
    $target    = $::syslog_ng::config_file_destination_files,
  ){
  syslog_ng::destination {$name:
    spec   => inline_template("file('${file}' <%= scope.function_template(['syslog_ng/fileparams.erb']) %>);"),
    target => $target
  }
  file {$file:
    ensure => file,
    owner  => $owner,
    group  => $group,
    mode   => $perm
  }
}
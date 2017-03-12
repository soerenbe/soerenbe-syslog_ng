require 'spec_helper'

describe 'syslog_ng' do

  it { is_expected.to contain_class('syslog_ng') }
  it { is_expected.to contain_class('syslog_ng::install') }
  it { is_expected.to contain_class('syslog_ng::params') }
  it { is_expected.to contain_class('syslog_ng::service') }
  it { is_expected.to contain_package('syslog-ng') }
  it { is_expected.to contain_package('rsyslog').with_ensure('absent') }
  it { is_expected.to contain_service('syslog_ng').with_ensure('running') }

  # Test for basic configuration
  it { is_expected.to contain_file('/etc/syslog-ng') }
  it { is_expected.to contain_file('/etc/syslog-ng/scl.conf') }
  it { is_expected.to contain_file('/etc/syslog-ng/syslog-ng.conf') }
  it { is_expected.to contain_file('/etc/syslog-ng/conf.d') }
  it { is_expected.to contain_file('/etc/syslog-ng/conf.d/15block_default_default.conf') }

  # Test the custom config files

  it { is_expected.to contain_concat('/etc/syslog-ng/conf.d/10sources.conf') }
  it { is_expected.to contain_concat('/etc/syslog-ng/conf.d/20destination_fallback.conf') }
  it { is_expected.to contain_concat('/etc/syslog-ng/conf.d/20destination_files.conf') }
  it { is_expected.to contain_concat('/etc/syslog-ng/conf.d/20destination_remote.conf') }
  it { is_expected.to contain_concat('/etc/syslog-ng/conf.d/30filter.conf') }
  it { is_expected.to contain_concat('/etc/syslog-ng/conf.d/40parser.conf') }
  it { is_expected.to contain_concat('/etc/syslog-ng/conf.d/50rewrite.conf') }
  it { is_expected.to contain_concat('/etc/syslog-ng/conf.d/80blocks.conf') }
  it { is_expected.to contain_concat('/etc/syslog-ng/conf.d/90logging.conf') }
  it { is_expected.to contain_concat('/etc/syslog-ng/conf.d/99fallback.conf') }

  # Default configuration

  it { is_expected.to contain_concat__fragment('s_src') }
  it { is_expected.to contain_syslog_ng__default('default') }
  it { is_expected.to contain_syslog_ng__source__system('s_src') }
  it { is_expected.to contain_syslog_ng__source('s_src') }

end
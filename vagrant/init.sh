test -e /var/cache/apt-updated || apt-get update
test -e /var/cache/apt-updated && echo 'Skipping apt-get update. /var/cache/apt-updated exists' || /bin/true
touch /var/cache/apt-updated
test -e /usr/bin/puppet || apt-get install -y puppet
mkdir -p /etc/puppet/modules
if [[ ! -e "/etc/puppet/modules/syslog_ng" ]]; then
  ln -s /vagrant /etc/puppet/modules/syslog_ng
fi
mkdir -p /etc/puppet/hiera
test -e /etc/puppet/modules/concat || puppet module install puppetlabs-concat
test -e /etc/puppet/modules/stdlib || puppet module install puppetlabs-stdlib

# Install puppet-lint
if [[ ! -e "/usr/local/bin/puppet-lint" ]]; then
  gem install puppet-lint
fi
# usage in the vagrant box:
# $ puppet-lint /etc/modules/syslog_ng


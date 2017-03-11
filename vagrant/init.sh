test -e /var/cache/apt-updated || apt-get update
test -e /var/cache/apt-updated && echo 'Skipping apt-get update. /var/cache/apt-updated exists' || /bin/true
touch /var/cache/apt-updated
test -e /usr/bin/puppet || apt-get install -y puppet
mkdir -p /etc/puppet/modules
mkdir -p /etc/puppet/hiera
test -e /etc/puppet/modules/concat || puppet module install puppetlabs-concat
test -e /etc/puppet/modules/stdlib || puppet module install puppetlabs-stdlib

# Install puppet-lint
gem install puppet-lint
# usage in the vagrant box:
# $ puppet-lint /vagrant


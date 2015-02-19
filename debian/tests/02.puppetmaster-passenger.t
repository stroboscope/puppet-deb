#!/bin/sh

test_description="puppetmaster-passenger"

. ./sharness.sh

test_token='82cc6efd-19e3-4f20-9ca8-58364f8a10d0'
server=$(facter fqdn)
tempfile=$(tempfile)

setup_puppet_conf() {
	cat > /etc/puppet/puppet.conf <<EOF
[main]
logdir=/var/log/puppet
vardir=/var/lib/puppet
ssldir=/var/lib/puppet/ssl
rundir=/var/run/puppet
factpath=/var/lib/puppet/lib/facter
templatedir=/etc/pupp/templates
server=${server}

[master]
ssl_client_header = SSL_CLIENT_S_DN 
ssl_client_verify_header = SSL_CLIENT_VERIFY
EOF
}

setup_site_pp() {
    cat > /etc/puppet/manifests/site.pp <<EOF
node default {
  file { '${tempfile}':
    ensure  => present,
    content => '${test_token}',
  }
}
EOF
}

test_expect_success "setup puppet.conf" "
  setup_puppet_conf
"

test_expect_success "setup site.pp" "
  setup_site_pp
"

test_expect_success "run puppet agent" "
  test_expect_code 2 puppet agent --test --detailed-exitcodes
"

test_expect_success "puppet should have added token to file" "
  grep -q $test_token $tempfile
"

test_done

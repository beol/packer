node default {
  class { '::selinux':
    mode => 'disabled',
  }

  sysctl { [ 'net.ipv6.conf.all.disable_ipv6', 'net.ipv6.conf.default.disable_ipv6' ]:
    ensure => present,
    value  => '1',
  }

  sshd_config { 'AddressFamily':
    ensure => present,
    value  => 'inet',
  }

  sshd_config { 'UseDNS':
    ensure => present,
    value  => 'no',
  }

  service { [ 'iptables', 'ip6tables' ]:
    ensure => stopped,
    enable => false,
  }

  include ::sudo

  sudo::conf { 'require-tty':
    priority => 0,
    content  => 'Defaults !requiretty',
  }

  class { '::ntp':
    servers    => [ '0.pool.ntp.org', '1.pool.ntp.org' ],
    interfaces => [ '127.0.0.1' ],
    restrict   => [
      'default ignore',
      '127.0.0.1',
      '0.pool.ntp.org nomodify notrap nopeer noquery',
      '1.pool.ntp.org nomodify notrap nopeer noquery'
    ],
  }

  include ::dnsmasq

  dnsmasq::conf { 'interface':
    ensure  => present,
    content => 'interface=lo
listen-address=127.0.0.1
bind-interfaces
',
    prio    => 0,
  }

  package { [ 'bind-utils', 'vim-enhanced' ]:
    ensure => present,
  }

  file { '/etc/dhcp/dhclient-eth0.conf':
    ensure => present,
  } ->
  file_line { 'prepend domain-name-servers':
    ensure => present,
    path   => '/etc/dhcp/dhclient-eth0.conf',
    line   => 'prepend domain-name-servers 127.0.0.1;',
  }
}

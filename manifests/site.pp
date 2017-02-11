node default {
  hiera_include('classes')

  #$sysctls = hiera('sysctls')
  #create_resources('sysctl', $sysctls)

  #$sshd_configs = hiera('sshd_configs')
  #create_resources('sshd_config', $sshd_configs)

  #$packages = hiera('packages')
  #create_resources('package', $packages)

  #$services = hiera('services')
  #create_resources('service', $services)

  #$dnsmasq_conf = hiera('dnsmasq::conf')
  #create_resources('dnsmasq::conf', $dnsmasq_conf)

  #file { '/etc/dhcp/dhclient-eth0.conf':
    #ensure => present,
  #} ->
  #file_line { 'prepend domain-name-servers':
    #ensure => present,
    #path   => '/etc/dhcp/dhclient-eth0.conf',
    #line   => 'prepend domain-name-servers 127.0.0.1;',
  #}

  $users = hiera('users')
  create_resources('user', $users)

  $ssh_authorized_keys = hiera('ssh_authorized_keys')
  create_resources('ssh_authorized_key', $ssh_authorized_keys)
}

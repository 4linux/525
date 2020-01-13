package {'ntp':
  ensure => installed,
}
-> file { '/etc/ntp.conf':
  ensure => file,
  mode   => '0600',
  source => '/vagrant/4525/files/ntp.conf'
}
~> service {'ntp':
  ensure  => running,
  enable  => true,
}

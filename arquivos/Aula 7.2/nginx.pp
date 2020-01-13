package {'nginx':
  ensure => installed,
  before => Service['nginx']
}

service {'nginx':
  ensure  => running,
  enable  => true,
  require => Package['nginx']
}

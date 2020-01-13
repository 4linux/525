class elastic_stack::nginx {

  package {'nginx':
  ensure  => installed,
  before  => Service['nginx']
  }

  file { 'virtualhost':
  path 	  => '/etc/nginx/sites-available/default',
  ensure  => present,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  source  => 'puppet:///modules/elastic_stack/default',
  require => Package['nginx'],
  notify  => Service['nginx']
  }


  service {'nginx':
  ensure  => running,
  enable  => true,
  require => File['virtualhost']
  }
}

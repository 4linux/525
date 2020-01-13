class elastic_stack::kibana {

  package {'kibana':
  ensure  => installed,
  before  => Service['kibana']
  }

  file { 'kibana.yml':
  path 	  => '/etc/kibana/kibana.yml',
  source  => 'puppet:///modules/elastic_stack/kibana.yml',
  require => Package['kibana'],
  notify  => Service['kibana']
  }

  service {'kibana':
  ensure  => running,
  enable  => true,
  require => File['kibana.yml']
  }
}

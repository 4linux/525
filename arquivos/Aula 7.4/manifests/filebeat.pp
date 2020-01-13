class elastic_stack::filebeat {

  package {'filebeat':
  ensure  => installed,
  before  => Service['filebeat']
  }

  file { 'filebeat.yml':
  path 	  => '/etc/filebeat/filebeat.yml',
  source  => 'puppet:///modules/elastic_stack/filebeat.yml',
  require => Package['filebeat'],
  notify  => Service['filebeat']
  }

  service {'filebeat':
  ensure  => running,
  enable  => true,
  require => File['filebeat.yml']
  }
}

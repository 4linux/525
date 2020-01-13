class elastic_stack::logstash {

  package {'logstash':
  ensure  => installed,
  before  => Service['logstash']
  }

  file { 'filebeat-input.conf':
  path 	  => '/etc/logstash/conf.d/filebeat-input.conf',
  source  => 'puppet:///modules/elastic_stack/filebeat-input.conf',
  require => Package['logstash'],
  }

  file { 'syslog-filter.conf':
  path 	  => '/etc/logstash/conf.d/syslog-filter.conf',
  source  => 'puppet:///modules/elastic_stack/syslog-filter.conf',
  require => Package['logstash'],
  }

  file { 'output-elasticsearch.conf':
  path 	  => '/etc/logstash/conf.d/output-elasticsearch.conf',
  source  => 'puppet:///modules/elastic_stack/output-elasticsearch.conf',
  require => Package['logstash'],
  }

  file_line {'JVM-logstash-XMS':
  path  => '/etc/logstash/jvm.options',
  line  => '-Xms512m',
  match => '-Xms1g',
  notify  => Service['logstash']
  }

  file_line {'JVM-logstash-XMX':
  path  => '/etc/logstash/jvm.options',
  line  => '-Xmx512m',
  match => '-Xmx1g',
  notify  => Service['logstash']
  }

  service {'logstash':
  ensure  => running,
  enable  => true,
  require => [ File['output-elasticsearch.conf'], File['filebeat-input.conf'] ]
  }
}

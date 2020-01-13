class elastic_stack::elasticsearch {

  package {'elasticsearch':
  ensure  => installed,
  before  => Service['elasticsearch']
  }

  file { 'elasticsearch.yml':
  path 	  => '/etc/elasticsearch/elasticsearch.yml',
  source  => 'puppet:///modules/elastic_stack/elasticsearch.yml',
  require => Package['elasticsearch'],
  }

  file_line {'JVM-elasticsearch-XMS':
  path  => '/etc/elasticsearch/jvm.options',
  line  => '-Xms512m',
  match => '-Xms1g',
  notify  => Service['elasticsearch']
  }

  file_line {'JVM-elasticsearch-XMX':
  path  => '/etc/elasticsearch/jvm.options',
  line  => '-Xmx512m',
  match => '-Xmx1g',
  notify  => Service['elasticsearch']
  }

  service {'elasticsearch':
  ensure  => running,
  enable  => true,
  require => File['elasticsearch.yml']
  }
}

class mariadb {

  package { 'mariadb-server':
  ensure  => present,
  }

  package { 'MySQL-python':
  ensure  => present,
  }

  file { 'wordpress.cnf':
  path    => '/etc/my.cnf.d/wordpress.cnf',
  source  => 'puppet:///modules/mariadb/wordpress.cnf',
  require => Package['mariadb-server'],
  notify  => Service['mariadb']
  }

  service {'mariadb':
  ensure  => running,
  enable  => true,
  require => File['wordpress.cnf']
  }

  mysql::db { 'wordpress':
  user     => 'wordpressuser',
  password => '4linux',
  host     => '10.5.25.100',
  grant    => ['SELECT', 'UPDATE'],
  before   => File['base.sql'],
  }

  file { 'base.sql':
  path    => '/tmp/base.sql',
  source  => 'puppet:///modules/mariadb/base.sql',
  require => Package['MySQL-python'],
  }

  exec { 'populando_base':
  command => 'mysql < /tmp/base.sql',
  path    => [ '/bin', '/usr/bin', '/usr/local/bin' ],
  cwd     => '/',
  require => File['base.sql'],
  }
}

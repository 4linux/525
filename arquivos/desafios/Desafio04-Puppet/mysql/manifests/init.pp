class mysql {

  $pacotes_mysql = [ 'mariadb-server', 'MySQL-python' ]

  package { $pacotes_mysql:
  ensure  => installed,
  alias   => 'pacotes',
  }

  file { 'wordpress.cnf':
  path 	  => '/etc/my.cnf.d/wordpress.cnf',
  source  => 'puppet:///modules/mysql/wordpress.cnf',
  require => Package['pacotes'],
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
  path 	  => '/tmp/base.sql',
  source  => 'puppet:///modules/mysql/base.sql',
  require => Package['pacotes'],
  }

  exec { 'populando_base':
  command => 'mysql < /tmp/base.sql',
  path    => [ '/bin', '/usr/bin', '/usr/local/bin' ],
  cwd     => '/',
  require => File['base.sql'],
  }
}

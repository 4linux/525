class wordpress {

  $pacotes_wordpress = [ 'apache2', 'php', 'libapache2-mod-php', 'php-mysql' ]

  package { $pacotes_wordpress:
  ensure  => installed,
  alias   => 'pacotes',
  }

  file {'/tmp/latest.tar.gz':
  path    => '/tmp/latest.tar.gz',
  source  => 'https://wordpress.org/latest.tar.gz',
  before  => File['wp-config.php']
  }

  exec { 'extraindo_wordpress':
  command => 'tar -xf /tmp/latest.tar.gz -C /var/www/',
  unless  => "test $(ls /var/www/ | grep -i 'wp-config.php' | wc -l) -eq 1",
  path    => [ '/bin', '/usr/bin', '/usr/local/bin' ],
  cwd     => '/',
  before  => File['wp-config.php']
  }

  file { 'wp-config.php':
  path 	  => '/var/www/wordpress/wp-config.php',
  source  => 'puppet:///modules/wordpress/wp-config.php',
  require => Package['pacotes'],
  notify  => Service['apache2']
  }

  file { '000-default.conf':
  path 	  => '/etc/apache2/sites-available/000-default.conf',
  source  => 'puppet:///modules/wordpress/000-default.conf',
  require => Package['pacotes'],
  notify  => Service['apache2']
  }

  service {'apache2':
  ensure  => running,
  enable  => true,
  require => File['wp-config.php']
  }
}

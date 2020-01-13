class inspec {

	file {'/opt/inspec.deb':
	  path      => '/opt/inspec.deb',
	  source    => 'https://packages.chef.io/files/stable/inspec/4.12.0/ubuntu/18.04/inspec_4.12.0-1_amd64.deb',
	  before    => Package['inspec']
	}

	package {'inspec':
	  ensure    => installed,
	  provider  => dpkg,
	  source    => '/opt/inspec.deb',
	  require   => File['/opt/inspec.deb']
	}
}

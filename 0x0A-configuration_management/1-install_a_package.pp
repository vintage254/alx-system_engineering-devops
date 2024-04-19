package { 'python3-pip':
  ensure => installed,
}

exec { 'install_flask':
  command     => '/usr/bin/pip3 install Flask==2.1.0',
  path        => ['/usr/bin'],
  environment => 'LANG=en_US.UTF-8',
  unless      => '/usr/bin/flask --version | grep "Flask 2.1.0"',
  require     => Package['python3-pip'],
}


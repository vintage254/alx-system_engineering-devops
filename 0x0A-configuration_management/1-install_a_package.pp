exec { 'install_flask':
  command => '/usr/bin/pip3 install flask==2.1.0',
  path    => '/usr/local/bin:/usr/bin:/bin', # Add the path to pip3 executable if necessary
  unless  => '/usr/local/bin/flask --version | grep "2.1.0"', # Check if Flask version 2.1.0 is already installed
}

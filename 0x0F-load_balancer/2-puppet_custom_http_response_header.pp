# Puppet manifest to customize a http header response

# Update packages before performing installations
exec { 'apt_update':
  command     => '/usr/bin/apt-get update',
  refreshonly => true,
}

package { 'nginx':
  ensure  => installed,
  require => Exec['apt_update'],
}

# Create an index.html page
file { '/var/www/html/index.html':
  ensure  => present,
  content => 'Hello World!',
}

# Perform a "moved permanently redirection" (301)
file_line { 'Redirect rule':
  path    => '/etc/nginx/sites-enabled/default',
  line    => 'server_name _;',
  match   => '^server_name _;$',
  after   => true,
  require => Package['nginx'],
}

file_line { 'Redirect rule implementation':
  path    => '/etc/nginx/sites-enabled/default',
  line    => '    rewrite ^/redirect_me https://github.com/besthor permanent;',
  match   => '^server_name _;$',
  after   => true,
  require => File_line['Redirect rule'],
}

# Create a 404 custom error page
file { '/var/www/html/404.html':
  ensure  => present,
  content => 'Ceci n\'est pas une page',
}

file_line { '404 error page configuration':
  path    => '/etc/nginx/sites-enabled/default',
  line    => 'error_page 404 /404.html;',
  match   => '^listen 80 default_server;$',
  after   => true,
  require => Package['nginx'],
}

# Create an HTTP response header
file_line { 'HTTP response header':
  path    => '/etc/nginx/sites-enabled/default',
  line    => "    add_header X-Served-By ${::hostname};",
  match   => '^server_name _;$',
  after   => true,
  require => Package['nginx'],
}

# Test configurations for syntax errors
exec { 'nginx_syntax_check':
  command => '/usr/sbin/nginx -t',
  path    => '/usr/bin:/bin',
  require => File['/var/www/html/index.html'],
}

# Restart nginx after implementing changes
service { 'nginx':
  ensure    => running,
  enable    => true,
  subscribe => File_line['Redirect rule implementation'],
}

# Puppet manifest to configure a new Ubuntu machine with Nginx
# and set up a custom HTTP response header

# Install Nginx package
package { 'nginx':
  ensure => installed,
}

# Service resource to manage the Nginx service
service { 'nginx':
  ensure  => running,
  enable  => true,
  require => Package['nginx'],
}

#Allow Nginx on the firewall
exec { 'allow_nginx':
  command => 'ufw allow "Nginx HTTP"',
  unless  => 'ufw status | grep "Nginx HTTP"',
  path    => '/usr/sbin:/usr/bin:/sbin:/bin',
}

# Define the content for the custom HTTP response header
$file_content = @(EOF)
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    # Set up custom HTTP response header
    add_header X-Served-By $::hostname;
    
    location / {
        root /var/www/html;
        index index.html index.htm;
    }
}
EOF

# Write the content to the Nginx default configuration file
file { '/etc/nginx/sites-available/default':
  ensure  => file,
  content => $file_content,
  notify  => Service['nginx'],
}

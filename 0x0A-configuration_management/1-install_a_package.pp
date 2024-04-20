#!/usr/bin/pup
# Install flask package using pip3
package { 'flask':
  ensure   => '2.1.0',
  provider => 'pip3'
}

package { 'werkzeug':
  ensure   => '2.1.0',
  provider => 'pip3'
}

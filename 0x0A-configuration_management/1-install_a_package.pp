#!/usr/bin/pup
# install flask
package { 'flask':
  provider => pip3,
  ensure => 2.1.0
}
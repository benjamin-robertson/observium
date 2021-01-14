# Class: observium::firewallufw
#
# Manage UFW on ubuntu
#
# @api private
#
class observium::firewallufw {
  assert_private()

  # Add rules for apache
  class { 'ufw': }
  if $observium::manage_ssl {
    ufw::allow { "Allow https access ${observium::apache_sslport}":
      port => $observium::apache_sslport,
      from => '0.0.0.0/0',
    }
  }
  else {
    ufw::allow { "Allow https access ${observium::apache_port}":
      port => $observium::apache_port,
      from => '0.0.0.0/0',
    }
  }
  # Ensure ssh is open
  ufw::allow { 'Allow ssh access 22':
    port => '22',
    from => '0.0.0.0/0',
  }
}

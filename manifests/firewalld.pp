# Class: observium::firewall
#
# Manages firewall and opens ports for observium
#
# @api private
#
class observium::firewalld {
  assert_private()

  class { 'firewalld': }
  # Check if we are using ssl
  if $observium::manage_ssl {
    # We are doing the ssl thing :)
    firewalld_port { "Open port ${observium::apache_sslport} for observium":
      ensure   => present,
      zone     => 'public',
      port     => $observium::apache_sslport,
      protocol => 'tcp',
    }
  }
  else {
    # not doing the ssl thing :(
    firewalld_port { "Open port ${observium::apache_port} for observium":
      ensure   => present,
      zone     => 'public',
      port     => $observium::apache_port,
      protocol => 'tcp',
    }
  }
}

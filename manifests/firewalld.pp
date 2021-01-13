# Class: observium::firewall
#
# Manages firewall and opens port for observium
#
class observium::firewalld {
  assert_private()
  # Check we are managing firewall
  if observium::manage_fw {
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
  case $facts['os']['family']  {
    'Debian': {
      firewall { '100 allow http and https access':
        dport  => [80, 443],
        proto  => 'tcp',
        action => 'accept',
      }
      firewall { '50 allow ssh access':
        dport  => [22],
        proto  => 'tcp',
        action => 'accept',
      }
    }
    default: { }
  }
}

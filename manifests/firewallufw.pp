# Class: observium::firewallufw
#
# Manage UFW on ubuntu
#
class observium::firewallufw {
  assert_private()

  if observium::manage_fw {
    # Add rules for apache
    class { 'ufw': }
    if $observium::manage_ssl {
      ufw::allow { "Allow https access ${observium::apache_sslport}"

      }
      firewall { "100 allow https access on ${observium::apache_sslport}":
        dport  => $observium::apache_sslport,
        proto  => 'tcp',
        action => 'accept',
      }
    }
    else {
      firewall { "100 allow http access on ${observium::apache_port}":
        dport  => $observium::apache_port,
        proto  => 'tcp',
        action => 'accept',
      }
    }
    # Ensure ssh is open
    firewall { '50 allow ssh access':
      dport  => [22],
      proto  => 'tcp',
      action => 'accept',
    }
  }
}

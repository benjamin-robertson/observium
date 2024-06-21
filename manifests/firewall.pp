# Class: observium::firewall
#
# Manage UFW on ubuntu
#
# @api private
#
class observium::firewall {
  assert_private()
  Firewall {
    require => undef,
  }

  # Default firewall rules
  firewall { '000 accept all icmp':
    proto => 'icmp',
    jump  => 'accept',
  }
  -> firewall { '001 accept all to lo interface':
    proto   => 'all',
    iniface => 'lo',
    jump    => 'accept',
  }
  -> firewall { '002 reject local traffic not on loopback interface':
    iniface     => '! lo',
    proto       => 'all',
    destination => '127.0.0.1/8',
    jump        => 'reject',
  }
  -> firewall { '003 accept related established rules':
    proto => 'all',
    state => ['RELATED', 'ESTABLISHED'],
    jump  => 'accept',
  }
  # Add rules for apache
  if $observium::manage_ssl {
    firewall { "50 Allow https access ${observium::apache_sslport}":
      dport => $observium::apache_sslport,
      proto => 'tcp',
      jump  => 'accept',
    }
  }
  else {
    firewall { "50 Allow http access ${observium::apache_port}":
      dport => $observium::apache_port,
      proto => 'tcp',
      jump  => 'accept',
    }
  }
  # Ensure ssh is open
  firewall { '004 Allow inbound SSH':
    dport => 22,
    proto => 'tcp',
    jump  => 'accept',
  }

  # ensure we drop all other traffic
  firewall { '999 drop all':
    proto  => 'all',
    jump   => 'drop',
    before => undef,
  }
}

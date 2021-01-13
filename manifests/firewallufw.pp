# Class: observium::firewallufw
#
# Manage UFW on ubuntu
#
class observium::firewallufw {
  assert_private()

  notify{ 'ran so much':}
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

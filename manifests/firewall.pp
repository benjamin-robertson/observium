# Class: observium::firewall
#
# Manages firewall and opens port for observium
#
class observium::firewall {
  class { 'firewalld': }
  firewalld_port { "Open port ${observium::apache_port} for observium":
    ensure   => present,
    zone     => 'public',
    port     => $observium::apache_port,
    protocol => 'tcp',
  }
}

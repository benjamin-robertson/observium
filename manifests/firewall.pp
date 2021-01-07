# Class: observium::firewall
#
# Manages firewall and opens port for observium
#
class observium::firewall {
  firewall { "Accept observium http traffic on port ${observium::apache_port}":
    proto  => 'tcp',
    action => 'accept',
    dport  => $observium::apache_port,
    zone   => 'public',
  }
}

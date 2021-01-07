# Class: observium::firewall
#
# Manages firewall and opens port for observium
#
class observium::firewall {
  class { 'firewalld': }
}

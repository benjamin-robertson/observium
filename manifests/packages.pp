# Class: observium::pInstall required packages
#
# Installs required packges for observium
#
class observium::packages {
  # Install required packages
  $required_packages = lookup('observium::required_packages', Array)
  package { $required_packages:
    ensure  => 'installed',
    require => Class['observium::yum'],
  }
}

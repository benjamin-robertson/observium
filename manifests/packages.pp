# Class: observium::pInstall required packages
#
# Installs required packges for observium
#
class observium::packages {
  assert_private()
  # Install required packages
  $required_packages = lookup('observium::required_packages', Array)
  package { $required_packages:
    ensure  => 'installed',
    require => Class['observium::yum'],
    before  => Exec['/sbin/alternatives --set python /usr/bin/python3'],
  }

  # Set python3 as /bin/python as observium expects this
  if $facts['os']['release']['major'] == '8' {
    exec { '/sbin/alternatives --set python /usr/bin/python3':
      creates => '/bin/python',
    }
  }

}

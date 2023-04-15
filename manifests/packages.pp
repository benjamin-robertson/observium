# Class: observium::packages
#
# Installs required packges for observium
#
# @api private
#
class observium::packages {
  assert_private()

  # Check what OS we are running on
  case $facts['os']['family'] {
    'RedHat': {
      case $facts['os']['release']['major'] {
        '7': {
          # Running on rhel 7
          $required_packages = lookup('observium::required_packages', Array)
          package { $required_packages:
            ensure  => 'installed',
            require => Class['observium::yum'],
          }
        }
        '8': {
          # Running on rhel 8
          $required_packages = lookup('observium::required_packages', Array)
          package { $required_packages:
            ensure  => 'installed',
            require => Class['observium::yum'],
            before  => Exec['/sbin/alternatives --set python /usr/bin/python3'],
          }

          # Set python3 as /bin/python as observium expects this
          exec { '/sbin/alternatives --set python /usr/bin/python3':
            creates => '/bin/python',
          }
        }
        default: { fail('Unsupported operating system, bailing out!!') }
      }
    }
    'Debian': {
      # Running on Ubuntu
      $required_packages = lookup('observium::required_packages', Array)
      package { $required_packages:
        ensure  => 'installed',
      }
    }
    default: { fail('Unsupported operating system, bailing out!!') }
  }
}

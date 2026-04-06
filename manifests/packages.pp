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
          $requirements = {
            require => Class['observium::yum'],
          }
        }
        '8': {
          # Running on rhel 8
          $required_packages = lookup('observium::required_packages', Array)
          $requirements = {
            require => Class['observium::yum'],
            before  => Exec['/sbin/alternatives --set python /usr/bin/python3'],
          }

          # Set python3 as /bin/python as observium expects this
          exec { '/sbin/alternatives --set python /usr/bin/python3':
            creates => '/bin/python',
          }
        }
        '9': {
          # Running on rhel 9
          $required_packages = lookup('observium::required_packages', Array)
          $requirements = {
            require => Class['observium::yum'],
          }
        }
        default: { fail('Unsupported operating system, bailing out!!') }
      }
    }
    'Debian': {
      $required_packages = lookup('observium::required_packages', Array)
      $requirements = {}
      # Enable universe package on 24.04
      if $facts['os']['release']['major'] == '24.04' {
        exec { '/usr/bin/add-apt-repository -y universe':
          unless => '/usr/bin/apt-cache policy | grep universe',
        }
      }
    }
    default: { fail('Unsupported operating system, bailing out!!') }
  }

  # install the required packages
  stdlib::ensure_packages(
    $required_packages,
    $requirements,
  )
}

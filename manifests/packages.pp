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
          stdlib::ensure_packages(
            $required_packages,
            {
              require => Class['observium::yum'],
            }
          )
        }
        '8': {
          # Running on rhel 8
          $required_packages = lookup('observium::required_packages', Array)
          stdlib::ensure_packages(
            $required_packages,
            {
              require => Class['observium::yum'],
              before  => Exec['/sbin/alternatives --set python /usr/bin/python3'],
            }
          )

          # Set python3 as /bin/python as observium expects this
          exec { '/sbin/alternatives --set python /usr/bin/python3':
            creates => '/bin/python',
          }
        }
        '9': {
          # Running on rhel 9
          $required_packages = lookup('observium::required_packages', Array)
          stdlib::ensure_packages(
            $required_packages,
            {
              require => Class['observium::yum'],
            }
          )
        }
        default: { fail('Unsupported operating system, bailing out!!') }
      }
    }
    'Debian': {
      $required_packages = lookup('observium::required_packages', Array)
      stdlib::ensure_packages($required_packages)
    }
    default: { fail('Unsupported operating system, bailing out!!') }
  }
}

# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include observium
class observium (
  String $dbpassword,
  String $rootdbpassword,
) {

# Check what OS we are on
  if $facts['os']['family'] == 'RedHat' {
    include observium::yum
  }

# install required packages
  $required_packages = lookup('observium::required_packages', Array)
  package { $required_packages:
    ensure => 'latest',
  }

# Setup mariadb
include observium::mariadb


Class['observium::yum'] -> Class['observium::mariadb']
}

# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include observium
class observium (
  String $db_password,
  String $rootdb_password,
  String $download_url,
  String $archive_name,
  String $db_host,
  String $db_user,
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

# Install observium binarys 
include observium::install

# Configure observium
include observium::config

# order class dependencies. 
Class['observium::yum'] -> Class['observium::mariadb']
}

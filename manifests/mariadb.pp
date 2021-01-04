# Class: observium
#
class observium::mariadb inherits observium {
  Class { '::mysql::server':
    package_name   => 'mariadb-server',
    package_ensure => 'present',
    service_name   => 'mariadb',
    root_password  => $dbpassword,
  }
}

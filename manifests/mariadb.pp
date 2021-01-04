# Class: observium
#
class observium::mariadb {
  Class { '::mysql::server':
    package_name   => 'mariadb-server',
    package_ensure => 'present',
    service_name   => 'mariadb',
    root_password  => $dbpassword,
  }
}

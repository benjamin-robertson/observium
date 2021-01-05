# Class: observium
#
class observium::mariadb inherits observium {
  Class { '::mysql::server':
    package_name   => 'mariadb-server',
    package_ensure => 'present',
    service_name   => 'mariadb',
    root_password  => $rootdbpassword,
  }

  mysql::db { 'observium':
    user     => 'observium',
    password => $dbpassword,
    host     => 'localhost',
    charset  => 'utf8',
    collate  => 'utf8_general_ci',
    grant    => 'ALL',
  }
}

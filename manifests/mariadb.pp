# Class: observium
#
class observium::mariadb {
  assert_private()
  Class { '::mysql::server':
    package_name   => 'mariadb-server',
    package_ensure => 'present',
    service_name   => 'mariadb',
    root_password  => $observium::rootdb_password,
  }

  mysql::db { 'observium':
    user     => $observium::db_user,
    password => $observium::db_password,
    host     => 'localhost',
    charset  => 'utf8',
    collate  => 'utf8_general_ci',
    grant    => 'ALL',
  }
}

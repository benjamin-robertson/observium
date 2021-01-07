# Class: observium
#
class observium::mariadb {
  assert_private()
  Class { '::mysql::server':
    package_name   => 'mariadb-server',
    package_ensure => 'present',
    service_name   => 'mariadb',
    root_password  => $rootdb_password,
  }

  mysql::db { 'observium':
    user     => $db_user,
    password => $db_password,
    host     => 'localhost',
    charset  => 'utf8',
    collate  => 'utf8_general_ci',
    grant    => 'ALL',
  }
}

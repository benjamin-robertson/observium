# Class: observium::mariadb
#
# Install mysql or mariadb - OS dependant
#
# @api private
#
class observium::mariadb {
  assert_private()
  # Check we are managing mysql
  if observium::manage_mysql {
    case $facts['os']['family'] {
      'RedHat': {
        Class { '::mysql::server':
          package_name   => 'mariadb-server',
          package_ensure => 'present',
          service_name   => 'mariadb',
          root_password  => $observium::rootdb_password,
        }
      }
      'Debian': {
        Class { '::mysql::server':
          #package_name   => 'mariadb-server',
          #package_ensure => 'present',
          #service_name   => 'mysqld',
          root_password    => $observium::rootdb_password,
          override_options => {
            'mysqld' => {
              'skip-log-bin' => '',
            },
          },
        }
      }
      default: { fail('Unsupported operating system, bailing out!!') }
    }

    mysql::db { 'observium':
      user     => $observium::db_user,
      password => $observium::db_password,
      host     => 'localhost',
      charset  => $observium::db_charset,
      collate  => 'utf8_general_ci',
      grant    => 'ALL',
    }
  }
}

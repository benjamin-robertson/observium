# Class: obversium
#
# Init the database after install.
#
class observium::database_init inherits observium {
  # init the database if the user table is not present
  exec { '/opt/observium/discovery.php -u':
    unless => "/bin/mysql -u observium --password=${db_password} observium -e 'select * from users'"
  }
}

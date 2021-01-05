# Class: observium::config
#
# Configure observium configuration files
#
class observium::config inherits observium {
  # Setup config.php
  file { '/opt/observium/config.php':
    ensure  => file,
    content => template('observium/config.epp', { 'db_host' => $db_host, 'db_user' => $db_user, 'db_password' => $db_password }),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}

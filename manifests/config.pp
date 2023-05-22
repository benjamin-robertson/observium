# Class: observium::config
#
# Configure observium configuration files
#
# @api private
#
# lint:ignore:140chars lint:ignore:arrow_alignment
class observium::config {
  # Setup config.php
  assert_private()
  # Lookup binary location for openssl
  $openssl_location = lookup(observium::openssl_location, String)
  # Lookup apache service name
  $apache_service = lookup(observium::apache_service, String)
  # Lookup fping location
  $fping_location = lookup(observium::fping_location, String)

  file { '/opt/observium/config.php':
    ensure  => file,
    content => epp('observium/config.epp', {
        'auth_mechanism' => $observium::auth_mechanism,
        'db_host' => $observium::db_host,
        'db_user' => $observium::db_user,
        'db_password' => $observium::db_password,
        'community' => $observium::community,
        'install_dir' => $observium::install_dir,
        'snmpv3_authlevel' => $observium::snmpv3_authlevel,
        'snmpv3_authname' => $observium::snmpv3_authname,
        'snmpv3_authpass' => $observium::snmpv3_authpass,
        'snmpv3_authalgo' => $observium::snmpv3_authalgo,
        'snmpv3_cryptopass' => $observium::snmpv3_cryptopass,
        'snmpv3_cryptoalgo' => $observium::snmpv3_cryptoalgo,
        'email_default' => $observium::email_default,
        'email_from' => $observium::email_from,
        'observium_additional_conf' => $observium::observium_additional_conf,
        'fping_location' => $fping_location
    }),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  # Create ssl key
  file { '/opt/observium/openssl.conf':
    ensure  => file,
    content => epp('observium/openssl.epp', { 'email_from' => $observium::email_from, 'apache_hostname' => $observium::apache_hostname }),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Exec['Create TLS cert'],
  }

  exec { 'Create TLS cert':
    command     => "${openssl_location} req -x509 -newkey rsa:4096 -keyout /etc/ssl/observium_key.pem -out /etc/ssl/observium_cert.pem -days 2000 -nodes -config /opt/observium/openssl.conf",
    refreshonly => true,
    notify      => Service[$apache_service],
  }

  # Lookup apache user for the OS we are running
  $apache_user = lookup(observium::apache_user, String)

  file { '/etc/ssl/observium_key.pem':
    mode    => '0400',
    owner   => $apache_user,
    group   => $apache_user,
    require => Exec['Create TLS cert'],
  }
  file { '/etc/ssl/observium_cert.pem':
    mode    => '0644',
    owner   => $apache_user,
    group   => $apache_user,
    require => Exec['Create TLS cert'],
  }

  file { '/opt/observium/html/.htaccess':
    ensure  => 'present',
    mode    => '0664',
    owner   => $apache_user,
    group   => $apache_user,
    content => template('observium/htaccess.epp'),
  }
}
# lint:endignore

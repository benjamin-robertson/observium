# Class: observium::config
#
# Configure observium configuration files
#
class observium::config {
  # Setup config.php
  assert_private()
  file { '/opt/observium/config.php':
    ensure  => file,
    content => epp('observium/config.epp', { 'db_host' => $observium::db_host, 'db_user' => $observium::db_user, 'db_password' => $observium::db_password, 'community' => $observium::community, 'snmpv3_authlevel' => $observium::snmpv3_authlevel,
    'snmpv3_authname' => $observium::snmpv3_authname, 'snmpv3_authpass' => $observium::snmpv3_authpass, 'snmpv3_authalgo' => $observium::snmpv3_authalgo, 'snmpv3_cryptopass' => $observium::snmpv3_cryptopass, 'snmpv3_cryptoalgo' => $observium::snmpv3_cryptoalgo,
    'email_default' => $observium::email_default, 'email_from' => $observium::email_from, 'observium_additional_conf' => $observium::observium_additional_conf }),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  # Create ssl key
  file { '/opt/observium/openssl.conf':
    ensure  => file,
    content => epp('observium/openssl.epp', { 'email_from' => $observium::email_from, 'apache_hostname' => $observium::apache_hostname}),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Exec['/bin/openssl req -x509 -newkey rsa:4096 -keyout /etc/ssl/observium_key.pem -out /etc/ssl/observium_cert.pem -days 2000 -nodes -config /opt/observium/openssl.conf'],
  }

  exec { '/bin/openssl req -x509 -newkey rsa:4096 -keyout /etc/ssl/observium_key.pem -out /etc/ssl/observium_cert.pem -days 2000 -nodes -config /opt/observium/openssl.conf':
    refreshonly => true,
    notify      => Service['httpd']
  }

  file { '/etc/ssl/observium_key.pem':
    mode    => '0400',
    owner   => 'apache',
    group   => 'apache',
    require => Exec['/bin/openssl req -x509 -newkey rsa:4096 -keyout /etc/ssl/observium_key.pem -out /etc/ssl/observium_cert.pem -days 2000 -nodes -config /opt/observium/openssl.conf'],
  }
  file { '/etc/ssl/observium_cert.pem':
    mode    => '0644',
    owner   => 'apache',
    group   => 'apache',
    require => Exec['/bin/openssl req -x509 -newkey rsa:4096 -keyout /etc/ssl/observium_key.pem -out /etc/ssl/observium_cert.pem -days 2000 -nodes -config /opt/observium/openssl.conf'],
  }
}

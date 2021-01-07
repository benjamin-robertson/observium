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
}

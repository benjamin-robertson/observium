# Class: observium::config
#
# Configure observium configuration files
#
class observium::config inherits observium {
  # Setup config.php
  file { '/opt/observium/config.php':
    ensure  => file,
    content => epp('observium/config.epp', { 'db_host' => $db_host, 'db_user' => $db_user, 'db_password' => $db_password, 'community' => $community, 'snmpv3_authlevel' => $snmpv3_authlevel, 'snmpv3_authname' => $snmpv3_authname, 'snmpv3_authpass' => $snmpv3_authpass, 'snmpv3_authalgo' => $snmpv3_authalgo, 'snmpv3_cryptopass' => $snmpv3_cryptopass, 'snmpv3_cryptoalgo' => $snmpv3_cryptoalgo, 'email_default' => $email_default, 'email_from' => $email_from, 'observium_additional_conf' => $observium_additional_conf }),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}

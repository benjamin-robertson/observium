# Class: observium::snmp
#
# Sets up SNMP locally to permit monitoring of local host out of the box.
#
# @api private
#
class observium::snmp {
  assert_private()
  # check if we are managing snmp
  if observium::manage_snmp {
    # lookup values for ubuntu 20.04 user, no native support in snmp module, otherwise return undef
    $ubuntu2004user = lookup(observium::debiansnmp_user)

    # concatenate miblocation arrays
    $mib_locations = $observium::mib_locations + $observium::additional_mib_location

    # Ensure snmp has proper config
    file { '/etc/snmp/snmp.conf':
      ensure  => file,
      owner   => $ubuntu2004user,
      group   => $ubuntu2004user,
      mode    => '0644',
      content => epp('observium/snmp.conf.epp', {
          'mib_locations'                => $mib_locations,
          'additional_snmp_conf_options' => $observium::additional_snmp_conf_options,
      }),
    }

    # Setup SNMP class with snmpv3 user
    class { 'snmp':
      snmpd_config             => ["rouser ${observium::snmpv3_authname} ${observium::snmpv3_authlevel}"],
      agentaddress             => $observium::snmpd_agentaddress,
      service_config_dir_group => $ubuntu2004user,
      service_config_dir_owner => $ubuntu2004user,
      varnetsnmp_owner         => $ubuntu2004user,
      varnetsnmp_group         => $ubuntu2004user,
    }

    # Set the users credentials
    snmp::snmpv3_user { $observium::snmpv3_authname:
      authpass => $observium::snmpv3_authpass,
      privpass => $observium::snmpv3_cryptopass,
    }
  }
}

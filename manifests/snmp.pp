# Class: observium::snmp
#
# Sets up SNMP locally to permit monitoring of local host out of the box.
#
class observium::snmp {
  assert_private()
  # check if we are managing snmp
  notify{ "We are ${observium::manage_snmp} snmp":}
  if observium::manage_snmp {
    # Setup SNMP class with snmpv3 user
    class { 'snmp':
      snmpd_config => ["rouser ${observium::snmpv3_authname} ${observium::snmpv3_authlevel}"],
    }

    # Set the users credentials
    snmp::snmpv3_user { $observium::snmpv3_authname:
      authpass => $observium::snmpv3_authpass,
      privpass => $observium::snmpv3_cryptopass,
    }
  }
}

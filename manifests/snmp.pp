# Class: observium::snmp
#
# Sets up SNMP locally to permit monitoring of local host out of the box.
#
class observium::snmp inherits observium {
  assert_private()
  # Setup SNMP class with snmpv3 user
  class { 'snmp':
    snmpd_config => ["rouser ${snmpv3_authname} ${snmpv3_authlevel}"],
  }

  # Set the users credentials
  snmp::snmpv3_user { $snmpv3_authname:
    authpass => $snmpv3_authpass,
    privpass => $snmpv3_cryptopass,
  }

}

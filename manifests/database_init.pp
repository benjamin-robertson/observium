# Class: obversium
#
# Init the database after install.
#
class observium::database_init inherits observium {
  # init the database if the user table is not present
  exec { '/opt/observium/discovery.php -u':
    unless => "/bin/mysql -u observium --password=${db_password} observium -e 'select * from users'"
  }

  exec { "/opt/observium/adduser.php admin ${admin_password} 10": 
    unless => "/bin/mysql -u observium --password=${db_password} observium -e 'select * from users WHERE username LIKE \"admin\"' | grep admin",
  }

  # add local host to database
  case $snmpv3_authlevel {
    'noAuthNoPriv': { $v3auth = 'nanp' }
    'authNoPriv':   { $v3auth = 'anp' }
    'authPriv':     { $v3auth = 'ap' }
    default:        { $v3auth = 'any' }
  }
  exec { "/opt/observium/add_device.php 127.0.0.1 ${v3auth} v3 ${snmpv3_authname} ${snmpv3_authpass} ${snmpv3_cryptopass} ${snmpv3_authalgo} ${snmpv3_cryptoalgo}":
    unless => "/bin/mysql -u observium --password=changeme observium -e 'select hostname from devices WHERE hostname LIKE \"127.0.0.1\"' | grep 127.0.0.1",
  }

  # Perform discovery for nodes which have been added. 
  exec { '/opt/observium/discovery.php -h all':
    subscribe   => Exec["/opt/observium/add_device.php 127.0.0.1 ${v3auth} v3 ${snmpv3_authname} ${snmpv3_authpass} ${snmpv3_cryptopass} ${snmpv3_authalgo} ${snmpv3_cryptoalgo}"],
    refreshonly => true,
  }

  exec { '/opt/observium/poller.php -h all':
    subscribe   => Exec["/opt/observium/add_device.php 127.0.0.1 ${v3auth} v3 ${snmpv3_authname} ${snmpv3_authpass} ${snmpv3_cryptopass} ${snmpv3_authalgo} ${snmpv3_cryptoalgo}"],
    refreshonly => true,
  }
}

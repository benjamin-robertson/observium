# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include observium
class observium (
  String $db_password,
  String $rootdb_password,
  String $download_url,
  String $archive_name,
  String $db_host,
  String $db_user,
  String $community,
  Enum['noAuthNoPriv','authNoPriv','authPriv'] $snmpv3_authlevel,
  String $snmpv3_authname,
  String $snmpv3_authpass,
  Enum['SHA','MD5'] $snmpv3_authalgo,
  String $snmpv3_cryptopass,
  Enum['AES','DES'] $snmpv3_cryptoalgo,
  String $email_default,
  String $email_from,
  String $admin_password,
  String $apache_bind_ip = $facts['ipaddress'],
  String $apache_hostname = $facts['hostname'],
  String $apache_port,
  Optional[Array] $observium_additional_conf = undef,
) {

# Check what OS we are on and install packages
  if $facts['os']['family'] == 'RedHat' {
    include observium::yum
  }

# install required packages
  include observium::packages

# Setup mariadb
  include observium::mariadb

# Install observium binary 
  include observium::install

# Configure observium
  include observium::config

# Database config
  include observium::database_init

# Disable selinux
  include observium::selinux

# Configure apache
  include observium::apache

# Configure localsnmp
  include observium::snmp

# order class dependencies. 
Class['observium::yum'] -> Class['observium::packages'] -> Class['observium::mariadb'] -> Class['observium::install'] -> Class['observium::config'] -> Class['observium::database_init']
}

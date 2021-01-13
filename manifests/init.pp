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
  String[8] $snmpv3_authpass,
  Enum['SHA','MD5'] $snmpv3_authalgo,
  String[8] $snmpv3_cryptopass,
  Enum['AES','DES'] $snmpv3_cryptoalgo,
  String $fping_location,
  String $email_default,
  String $email_from,
  String $admin_password,
  String $apache_bind_ip = $facts['ipaddress'],
  String $apache_hostname = $facts['hostname'],
  String $apache_port,
  String $apache_sslport,
  String $custom_ssl_cert,
  String $custom_ssl_key,
  Boolean $manage_repo,
  Boolean $manage_selinux,
  Boolean $manage_fw,
  Boolean $manage_snmp,
  Boolean $manage_mysql,
  Boolean $manage_apache,
  Boolean $manage_apachephp,
  Boolean $manage_ssl,
  Optional[Hash] $repos = undef,
  Optional[Hash] $gpgkeys = undef,
  Optional[Array] $observium_additional_conf = undef,

) {

  # Check what OS we are on and install packages
  case $facts['os']['family'] {
    'RedHat': { include observium::yum }
    'Debian': {}
    default: { fail('Unsupported operating system, bailing out!!') }
  }

  # install required packages
  include observium::packages

  # Setup mariadb\mysql
  include observium::mariadb

  # Install observium binary 
  include observium::install

  # Configure observium
  include observium::config

  # Database config
  include observium::database_init

  # Disable selinux
  if $facts['os']['family'] == 'RedHat' {
    include observium::selinux
  }

  # Configure apache
  include observium::apache

  # Configure localsnmp
  include observium::snmp

  # Configure firewall
  if $facts['os']['family'] == 'RedHat' {
    include observium::firewalld
  }

  # order class dependencies for each OS
  case $facts['os']['family'] {
    'RedHat': {
      Class['observium::selinux'] -> Class['observium::yum'] -> Class['observium::packages'] -> Class['observium::mariadb'] -> Class['observium::install'] -> Class['observium::config'] -> Class['observium::snmp'] -> Class['observium::database_init']
    }
    'Debian': {
      #Class['observium::packages'] -> Class['observium::mariadb'] -> Class['observium::install'] -> Class['observium::config'] -> Class['observium::snmp'] -> Class['observium::database_init']
      Class['observium::packages'] -> Class['observium::mariadb'] -> Class['observium::install'] -> Class['observium::config'] -> Class['observium::database_init']
    }
    default: { fail('Unsupported operating system, bailing out!!') }
  }

}

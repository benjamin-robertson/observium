# @summary A short summary of the purpose of this class
#
# Observium base class which accepts parameters to customise the observium install 
#
# @example
#   include observium
class observium (
  String $db_password, # Mysql password for observium user
  String $rootdb_password, # Mysql root password
  String $download_url, # Url to the installer, IE http://observium.com/, can be a file path
  String $installer_name, # Installer name, IE observium-installer.tar
  String $db_host, # Database host to use
  String $db_user, # Database user to use
  String $community, # Default SNMP community to configure
  Enum['noAuthNoPriv','authNoPriv','authPriv'] $snmpv3_authlevel, # Deafult SNMP authlevel to use
  String $snmpv3_authname, # SNMP Authname SNMPv3 user
  String[8] $snmpv3_authpass, # Auth password
  Enum['SHA','MD5'] $snmpv3_authalgo, # Auth algorithm SHA, MD5
  String[8] $snmpv3_cryptopass, # Crypto pass
  Enum['AES','DES'] $snmpv3_cryptoalgo, # Crypto algo AES, DES
  String $fping_location, # Fping location
  String $email_default,
  String $email_from,
  String $admin_password, # Admin password GUI
  String $apache_bind_ip = $facts['ipaddress'], # Bind IP address
  String $apache_hostname = $facts['hostname'], # Apache hostname
  String $apache_port, # Apache non SSL port
  String $apache_sslport, # Apache SSL port
  String $custom_ssl_cert, # SSL cert location
  String $custom_ssl_key, # SSL cert key
  Boolean $manage_repo, # Manage repo, RHEL only
  Boolean $manage_selinux, # Manage selinux, RHEL only
  Boolean $manage_fw, # Manage FW, enabled RHEL by default only. 
  Boolean $manage_snmp, # Manage SNMP, configure SNMP locally with SNMPv3 creds, enable by default
  Boolean $manage_mysql, # Manage mysql, enable by default, configure mysql backend.
  Boolean $manage_apache, # Configure and setup and Apache, otherwise setup virtial host only
  Boolean $manage_apachephp, # Configure and setup Apachemod php. 
  Boolean $manage_ssl, # Setup the web site as SSL. If no cert provided, a self signed one will be used. 
  Optional[Hash] $repos = undef, # Customise reposiotry for RedHat
  Optional[Hash] $gpgkeys = undef, # Customise GPG keys for red hat.
  Optional[Array] $observium_additional_conf = undef, # Array of additional configurations options to add to /opt/observium/config.php

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
  if $manage_fw {
    case $facts['os']['family'] {
      'RedHat': { include observium::firewalld }
      'Debian': { include observium::firewallufw }
      default: { }
    }
  }

  # order class dependencies for each OS
  case $facts['os']['family'] {
    'RedHat': {
      Class['observium::selinux'] -> Class['observium::yum'] -> Class['observium::packages'] -> Class['observium::mariadb'] -> Class['observium::install'] -> Class['observium::config'] -> Class['observium::snmp'] -> Class['observium::database_init']
    }
    'Debian': {
      Class['observium::packages'] -> Class['observium::mariadb'] -> Class['observium::install'] -> Class['observium::config'] -> Class['observium::snmp'] -> Class['observium::database_init']
    }
    default: { fail('Unsupported operating system, bailing out!!') }
  }

}

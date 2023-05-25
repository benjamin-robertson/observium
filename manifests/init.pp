# @summary A short summary of the purpose of this class
#
# Observium base class which accepts parameters to customise the observium install. 
#
# lint:ignore:140chars
#
# @example
#   include observium
# 
# @param auth_mechanism
#     Auth mechanism to use
#     default: mysql
#
# @param db_password
#     Mysql password for observium user - default 'changeme'
# 
# @param rootdb_password
#     Mysql root password - default 'hello123'
# 
# @param download_url
#     Url to the installer, IE http://observium.com/, can be a file path - default 'http://www.observium.org/'
# 
# @param installer_name
#     Installer name, IE observium-installer.tar - default 'observium-community-latest.tar.gz'
# 
# @param install_dir
#     Install directory - default '/opt/observium'
#
# @param db_host
#     Database host to use - default 'localhost'
#
# @param db_user
#     Database user to use - default 'observium'
#
# @param db_charset
#     Database charset to use - default 'utf8' Ubuntu 20.04 'utf8mb3'
#
# @param community
#     Default SNMP community to configure - default 'puppet'
# 
# @param snmpv3_authlevel
#     Default SNMP authlevel to use - default 'authPriv'
#     Valid options - ['noAuthNoPriv','authNoPriv','authPriv']
#
# @param snmpv3_authname
#     SNMP Authname SNMPv3 user - default 'observium'
# 
# @param snmpv3_authpass
#     Auth password - min 8 character
# 
# @param snmpv3_authalgo
#     Auth algorithm - defualt 'SHA'
#     Valid options - ['SHA','MD5']
# 
# @param snmpv3_cryptopass
#     Crypto pass - min 8 character
#
# @param snmpv3_cryptoalgo
#     Crypto algorithm - default 'AES'
#     Valid options - ['AES','DES']
# 
# @param fping_location
#     Change if fping is in a non default locaiton - default, RHEL '/sbin/fping' Ubuntu '/usr/bin/fping'
#
# @param email_default
#     Not setup yet, use additional config option to setup email default
#
# @param email_from
#     Not setup yet, use additional config option to setup email from
#
# @param admin_password
#     Admin password for the default admin observium user - default 'changeme'
#
# @param apache_access_log_file
#     Apache access log file - default '/opt/observium/logs/access_log'
#
# @param apache_bind_ip
#     Bind IP address - default $facts['ipaddress']
#
# @param apache_error_log_file
#     Apache error log file - default '/opt/observium/logs/error_log'
#
# @param apache_hostname
#     Apache hostname for observium site - default $facts['hostname']
#
# @param apache_port
#     Apache non SSL port - note if SSL is enabled this will have no effect - default '80'
#
# @param apache_sslport
#     Apache SSL port - note if SSL isn't enable this will have no effect - defautl '443'
#
# @param custom_ssl_cert
#     Path to SSL certificate, note this module will automatically create a cert in this location '/etc/ssl/observium_cert.pem' - default '/etc/ssl/observium_cert.pem'
#
# @param custom_ssl_key
#     Path to SSL certificate key, note this module will automatically create a key in this location '/etc/ssl/observium_key.pem' - default '/etc/ssl/observium_key.pem'
#
# @param manage_repo
#     Manage repo, RHEL only, - default true
#
# @param manage_selinux
#     Manage selinux, RHEL only. This will set selinux to permissive mode as observium havn't published a selinux profile - default true
#
# @param manage_fw
#     Manage firewalld on RHEL. UFW on ubuntu. - default RHEL true, Ubuntu false
#
# @param manage_snmp
#     Configure snmpd on the observium and add to observium - default true
#
# @param manage_mysql
#     Install and configure mysql, - default true
#
# @param manage_apache
#     Install and configure Apache, - defalt true
#
# @param manage_apachephp
#     Configure Apachemod php, - default true
#
# @param manage_ssl
#     Setup the web site as SSL. If no cert provided, a self signed one will be used. - default false
#
# @param repos
#     Customise repoistory locations for RedHat
#
# @param gpgkeys
#     Customise GPG keys for RedHat
#
# @param observium_additional_conf
#     Array of additional configurations options to add to /opt/observium/config.php
#
# lint:ignore:parameter_order
class observium (
  String                                       $auth_mechanism,
  String                                       $db_password,
  String                                       $rootdb_password,
  String                                       $download_url,
  String                                       $installer_name,
  String                                       $install_dir,
  String                                       $db_host,
  String                                       $db_user,
  String                                       $db_charset,
  String                                       $community,
  Array[String]                                $custom_rewrite_lines      = [],
  Enum['noAuthNoPriv','authNoPriv','authPriv'] $snmpv3_authlevel,
  String                                       $snmpv3_authname,
  String                                       $snmpv3_authpass,
  Enum['SHA','MD5']                            $snmpv3_authalgo,
  String                                       $snmpv3_cryptopass,
  Enum['AES','DES']                            $snmpv3_cryptoalgo,
  String                                       $fping_location,
  String                                       $email_default,
  String                                       $email_from,
  String                                       $admin_password,
  String                                       $apache_bind_ip            = $facts['networking']['ip'],
  String                                       $apache_hostname           = $facts['networking']['hostname'],
  Hash                                         $apache_custom_options,
  String                                       $apache_auth_require,
  Stdlib::Port                                 $apache_port,
  Stdlib::Port                                 $apache_sslport,
  String                                       $custom_ssl_cert,
  String                                       $custom_ssl_key,
  Boolean                                      $manage_repo,
  Boolean                                      $manage_selinux,
  Boolean                                      $manage_fw,
  Boolean                                      $manage_snmp,
  Boolean                                      $manage_mysql,
  Boolean                                      $manage_apache,
  Boolean                                      $manage_apachephp,
  Boolean                                      $manage_ssl,
  Optional[String]                             $apache_error_log_file     = undef,
  Optional[String]                             $apache_access_log_file    = undef,
  Optional[Hash]                               $repos                     = undef,
  Optional[Hash]                               $gpgkeys                   = undef,
  Optional[Array]                              $observium_additional_conf = undef,
) {
  # lint:endignore

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
      default: {}
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
    default: {
      fail('Unsupported operating system, bailing out!!')
    }
  }
}
# lint:endignore

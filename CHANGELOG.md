# Changelog

All notable changes to this project will be documented in this file.

## Release 3.0.0

**Upgrade warning**

The following default parameters for passwords have been removed from the module.
- observium::db_password
- observium::rootdb_password
- observium::snmpv3_authpass
- observium::snmpv3_cryptopass
- observium::admin_password

If you were relying on these defaults you will need to set them in your control repo hiera before upgrading to 3.0.0. Passwords and other sensitive data in your control repo should be encrypted and protected, see https://www.puppet.com/docs/puppet/8/securing-sensitive-data.html.

**Features**

- Added support for RHEL9
- Added support for stdlib 9.0 or later. **Note:** the observium module itself supports stdlib 9, however its dependencies did not. When upgrading to stdlib 9 please ensure you upgrade other dependant modules.
- Incorporated security recommendations from baile320, removal of default passwords. 
- Bumped module dependencies to later versions.
- Bumped PDK version to 3.2.0.
- Lint and other minor fixes. 
- Added lint, unit and litmus tests within Github actions pipeline.

Thanks to https://github.com/baile320 for their security recommendations for this release. :)

## Release 2.0.0

**Features**

- Added support for Ubuntu 22.04
- Bump PDK to 2.6.1
- Allow users to customise observium installation directory via 'install_dir' parameter.
- Allow users to specify mysql auth mechanism via 'auth_mechanism' parameter.
- Added observium snmp mib locations to snmp.conf. User can customise these via the 'mib_locations' and 'additional_mib_location' parameters.
- Added 'apache_custom_options' parameter to specify custom options for apache::vhost directory.
- Added 'apache_auth_require' parameter to specify Apache auth require
- Added ability to specify Apache error and access log location via parameter.

**Bugfixes**

- Updated GPG for OpenNMS yum repos. This was causing installations to fail on RHEL7 and 8. https://www.opennms.com/en/blog/2023-02-13-security-update-mandatory-gpg-key-rotation-for-meridian-and-horizon/

**Deprecations**
 
- Deprecated support for Ubuntu 18.04
- Dropped Puppet 6 support
- **Warning:** If upgrading puppetlabs-mysql from version <13 to version >= 13 may cause issues with existing mysql installations. Proceed with caution. This results in any Ubuntu 20.04 or later systems being switched from using mysql to mariadb uncleanly.

Thanks to https://github.com/i0dev for their efforts on this release :)

## Release 1.0.0

**Features**

- First non-beta release.
- Can upgrade to this new version from earlier versions without affecting existing installations.
- Updated module dependencies, removing redundant and deprecated modules.
- Added all dependencies based on dependency dependencies.
- Refactored code to making it easier to debug.
- Setup Rspec testing for module
- Updated module to latest pdk 2.1.0
- Added db_charset option - see reference. 

**Bugfixes**

- Fixed issue causing continuous corrective changes on Ubuntu 20.04, 18.04 and RHEL7.
  - Observium installation documentation instructs to install packages which don't exist. This was causing the corrective change on Ubuntu 18.04 and RHEL7.
- Fixed lint issues in code

## Release 0.1.3

**Features**

**Bugfixes**

- Included php-ldap package by default. Not including this package causes issues if LDAP auth is configured for observium using observium_additional_conf. See https://github.com/benjamin-robertson/observium/pull/1 for more details. Thanks to https://github.com/egypcio

**Known Issues**

## Release 0.1.2

**Features**

- Initial release

**Bugfixes**

**Known Issues**

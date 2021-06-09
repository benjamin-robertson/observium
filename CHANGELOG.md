# Changelog

All notable changes to this project will be documented in this file.

## Release 1.0.0

**Features**

- First non-beta release.
- Can upgrade to this new version from earlier versions without affecting existing installations.
- Updated module dependencies, removing redundant and deprecated modules.
- Added all dependencies based on dependency dependencies.
- Refactored code to making it easier to debug.
- Setup Rspec testing for module
- Updated module to latest pdk 2.1.0

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

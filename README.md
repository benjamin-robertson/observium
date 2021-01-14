# observium

A Puppet module which installs and configures Observium monitoring software. For infomation about observium please see [Observium][1]


## Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with observium](#setup)
    * [What observium affects](#what-observium-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with observium](#beginning-with-observium)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

A Puppet module to install Observium in a basic configuration on Ubuntu or RedHat. 

## Setup

### What observium affects

Observium installs and configures the following by default, 

- Apache
- Mysql or MariaDB
- Enable EPEL, remi-php and OpenNMS yum repo on RHEL. 
- Modifies\enables firewalld on RHEL
- Installs required packages for Observium
- Installs Observium software on the system
- Configures Obersvium software on the system
- Sets selinux into permissive mode on RHEL
- Configures SNMP v3 on the observium host
- Creates a certificate and key pay under /etc/ssl/observium_key.pem and observium_cert.pem

If you are managing yumrepos, firewall, selinux, snmp, mysql, apache you can disable this module managing them by setting manage_{service} to false. See reference.

### Setup Requirements

Please ensure you meet the dependency requirements and have the following in your Puppetfile.

- puppetlabs-stdlib
- puppet-archive
- puppetlabs-yumrepo_core - only required for RHEL
- puppetlabs-mysql
- puppetlabs-cron_core
- puppet-selinux - only required for RHEL
- puppetlabs-apache
- puppet-snmp
- puppet-firewalld - only required for RHEL and if managing firewall
- puppetlabs-resource_api
- domkrm-ufw - only required for Ubuntu and if managing firewall
- puppetlabs-translate
- camptocamp-systemd


### Beginning with observium

In its most basic form you can install observium by
```
include observium
```

## Usage

Please see reference for details instructions on observium class paramaters. 

# Basic usage



## Limitations

Observium doesn't appear to give an option to download anything other than the latest release of community edition Observium. 
I originally intended to provide an option of which version of Observium to install. 

Tested with the following setups.

- PE 2019.8.4
    - Puppet 6.19.1
- RHEL
    - 7
    - 8
- Ubuntu
    - 18.04 LTS
    - 20.04 LTS

## Upgrading Observium 
Please see [Upgrading][2] on steps from Observium to upgrade. If you are managaing Observium with Puppet, 
please disable Puppet agent on your server before performing the upgrade steps. This module looks for the 
presence of '/opt/observium/VERSION' before extracting the observium tar ball. You can reenable Puppet 
once the upgrade is complete. 


## Development

If you find any issues with this module, please log them in the issues register of the GitHub project. [Issues][3]

[1]: https://www.observium.org/
[2]: https://docs.observium.org/updating/#community-edition
[3]: https://github.com/benjamin-robertson/observium/issues


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

Include usage examples for common use cases in the **Usage** section. Show your
users how to use your module to solve problems, and be sure to include code
examples. Include three to five examples of the most important or common tasks a
user can accomplish with your module. Show users how to accomplish more complex
tasks that involve different types, classes, and functions working in tandem.

## Limitations

Observium don't appear to give an option to download anythig other than the latest release

Only tested with the following setups.

- Puppet 
    - test

Upgrading Observium. 

## Development

In the Development section, tell other users the ground rules for contributing
to your project and how they should submit their work.

## Release Notes/Contributors/Etc. **Optional**

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You can also add any additional sections you feel are
necessary or important to include here. Please use the `##` header.

[1]: https://www.observium.org/
[2]: https://puppet.com/docs/puppet/latest/puppet_strings.html


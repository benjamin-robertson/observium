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

Observium module installs and configures the following by default, 

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

If you are managing yumrepos, firewall, selinux, snmp, mysql, apache within your control-repo you can disable 
configuring this by setting manage_{service} to false. See reference.

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

### Basic usage

1. Setup Observium with custom certificates
```
class { 'observium': 
    manage_ssl      => true,
    custom_ssl_cert => '/opt/observium/ssl/cert.pem',
    custom_ssl_key  => '/opt/observium/ssl/key.pem',
}
```
2. Setup Observium without managing Firewall or Apache (Note: you will need to configure apache manually or with another Puppet module)
```
class { 'observium':
    manage_fw     => false,
    manage_apache => false,
}
```
3. Setup Observium on RHEL, specifying local repo and install location of Observium, can also be performed with Hiera.
If your EPEL was hosted at myrepo.local and you saved the observium installer under /tmp
```
$my_repo = { 'epel' => {
    'ensure'   => 'present',
    'enabled'  => '1',
    'descr'    => 'Extra packages for enterprise linux',
    'baseurl'  => 'http://myrepo.local/epel7',
    'gpgcheck' => '1',
    'gpgkey'   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7',
    'target'   => '/etc/yum.repos.d/epel.repo',
    },
}

class { 'observium':
    repos          => $my_repo,
    download_url   => '/tmp/',
    installer_name => 'observium-community-latest.tar.gz',
}
```

## Limitations

Observium doesn't provide an option to download anything other than the latest release of community edition Observium. 
I originally intended to provide an option of which version of Observium to install. This module will just install the latest Observium release.

Tested with the following setups.

- PE 2021.7.2
    - Puppet 7.21.0
- RHEL
    - 7
    - 8
- Rocky
    - 8
- Ubuntu
    - 20.04 LTS
    - 22.04 LTS

### RHEL specific limitations

RHEL 7 requires the following yum repos for installation - these will be automatically added if you host has internet connection.

- [EPEL][4]
- [OpenNMS common][5]
- [OpenNMS RHEL7][6]
- [remi-php72][7]
- [remi-safe][8]

RHEL 8 require the follwing yum repos for installation - these will be automatically added if you host has internet connection.

- [EPEL][4]
- [OpenNMS common][5]
- [OpenNMS RHEL8][9]
- [remi-modular][10] - note you will need to enable php7.2 after adding this repo 
```
/bin/dnf module -y install php:remi-7.2
```
- [remi-safe][10]


## Upgrading Observium 
Please see [Upgrading][2] steps from Observium to upgrade. If you are managaing Observium with Puppet, 
please disable Puppet agent on your server before performing the upgrade steps. This module looks for the 
presence of '/opt/observium/VERSION' before extracting the observium tar ball. You can reenable Puppet 
once the upgrade is complete. 

To disable Puppet manually on a host.
```
puppet agent --disable
```
To reenable
```
puppet agent --enable
```

## Development

If you find any issues with this module, please log them in the issues register of the GitHub project. [Issues][3]

[1]: https://www.observium.org/
[2]: https://docs.observium.org/updating/#community-edition
[3]: https://github.com/benjamin-robertson/observium/issues
[4]: https://fedoraproject.org/wiki/EPEL
[5]: https://yum.opennms.org/stable/common/
[6]: https://yum.opennms.org/stable/rhel7/
[7]: http://cdn.remirepo.net/enterprise/7/php72/mirror
[8]: http://cdn.remirepo.net/enterprise/7/safe/mirro
[9]: https://yum.opennms.org/stable/rhel8/
[10]: https://rpms.remirepo.net/enterprise/8/


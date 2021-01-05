# Class: observium::Create folder sturcture
#
class observium::install {
  # Create folder sturctureo 
  file {
    default:
      owner => 'root',
      group => 'root',
      mode  => '0775',
  }

  file { '/opt/observium':
    ensure => directory,
  }

  file { '/opt/observium/rrd':
    ensure => directory,
    owner  => 'apache',
    group  => 'apache',
  }

  # Download installation tar ball
  file { '/opt/observium-community-latest.tar.gz':
    ensure => file,
    source => 'http://www.observium.org/observium-community-latest.tar.gz',
  }
}

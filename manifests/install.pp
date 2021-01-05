# Class: observium::Create folder sturcture
#
class observium::install inherits observium {
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
    ensure  => directory,
    owner   => 'apache',
    group   => 'apache',
    require => File['/opt/observium'],
  }

  # Download installation tar ball
  #file { '/opt/observium-community-latest.tar.gz':
  #  ensure => file,
  #  source => 'http://www.observium.org/observium-community-latest.tar.gz',
  #}

  # Extract the tarball
  archive { $archive_name:
    path         => "/opt/${archive_name}",
    source       => "${downloadurl}/${archive_name}",
    extract      => true,
    extract_path => '/opt/observium',
    creates      => '/opt/observium/VERSION',
    cleanup      => false,
    require      => File['/opt/observium'],
  }
}

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

  # Extract the tarball
  archive { $archive_name:
    path         => "/opt/${archive_name}",
    source       => "${download_url}/${archive_name}",
    extract      => true,
    extract_path => '/opt',
    creates      => '/opt/observium/VERSION',
    cleanup      => false,
    require      => File['/opt/observium'],
  }

  file { '/opt/observium/logs':
    ensure  => directory,
    owner   => 'apache',
    group   => 'apache',
    require => File['/opt/observium'],
  }

  file { '/etc/cron.d/observium': 
    ensure  => file,
    mode    => '0644',
    content => file('observium/cron.txt'),
  }
}

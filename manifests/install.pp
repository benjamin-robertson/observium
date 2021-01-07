# Class: observium::Create folder sturcture
#
class observium::install {
  assert_private()
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
  archive { $observium::archive_name:
    path         => "/opt/${observium::archive_name}",
    source       => "${observium::download_url}/${observium::archive_name}",
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

  # include cron to manage cron service
  #include cron
  # include cron file for observium
  #file { '/etc/cron.d/observium':
  #  ensure  => file,
  #  mode    => '0644',
  #  content => file('observium/cron.txt'),
  #  notify  => Service['crond'],
  #}
  cron { 'discovery all devices':
    command => '/opt/observium/discovery.php -h all >> /dev/null 2>&1',
    user    => 'root',
    hour    => '*/6',
    minute  => '33',
  }
}

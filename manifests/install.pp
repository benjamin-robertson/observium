# Class: observium::install
#
# Creates folder structure for Observium, and install from tar
#
# @api private
#
class observium::install {
  assert_private()
  # Lookup apache user for the OS we are running
  $apache_user = lookup(observium::apache_user, String)

  # Extract the tarball
  archive { $observium::installer_name:
    path          => "/opt/${observium::installer_name}",
    source        => "${observium::download_url}${observium::installer_name}",
    extract       => true,
    extract_path  => '/opt',
    extract_flags => {
      'tar' => '--no-same-owner -xf',
    },
    creates       => '/opt/observium/VERSION',
    cleanup       => false,
  }

  file { '/opt/observium/rrd':
    ensure  => directory,
    owner   => $apache_user,
    group   => $apache_user,
    mode    => '0775',
    require => Archive[$observium::installer_name],
  }

  file { '/opt/observium/logs':
    ensure  => directory,
    owner   => $apache_user,
    group   => $apache_user,
    mode    => '0775',
    require => Archive[$observium::installer_name],
  }

  # Ensure observium cron jobs are populated
  cron { 'discovery all devices':
    command => '/opt/observium/discovery.php -h all >> /dev/null 2>&1',
    user    => 'root',
    hour    => '*/6',
    minute  => '33',
  }

  cron { 'discovery newly added devices':
    command => '/opt/observium/discovery.php -h new >> /dev/null 2>&1',
    user    => 'root',
    minute  => '*/5',
  }

  cron { 'multithreaded pooler wrapper':
    command => '/opt/observium/poller-wrapper.py >> /dev/null 2>&1',
    user    => 'root',
    minute  => '*/5',
  }

  cron { 'daily housekeeping for syslog, eventlog and alert log':
    command => '/opt/observium/housekeeping.php -ysel',
    user    => 'root',
    hour    => '5',
    minute  => '13',
  }

  cron { 'housekeeping script daily for rrds, ports, orphaned entries in the database and performance data':
    command => '/opt/observium/housekeeping.php -yrptb',
    user    => 'root',
    hour    => '4',
    minute  => '47',
  }
}

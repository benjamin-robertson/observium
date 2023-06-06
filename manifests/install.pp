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

  # Create folder structure
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
    owner   => $apache_user,
    group   => $apache_user,
    require => File['/opt/observium'],
  }

  # Extract the tarball
  archive { $observium::installer_name:
    path         => "/opt/${observium::installer_name}",
    source       => "${observium::download_url}${observium::installer_name}",
    extract      => true,
    extract_path => '/opt',
    creates      => '/opt/observium/VERSION',
    cleanup      => false,
    require      => File['/opt/observium'],
  }

  file { '/opt/observium/logs':
    ensure  => directory,
    owner   => $apache_user,
    group   => $apache_user,
    require => File['/opt/observium'],
  }

  # Ensure observium cron jobs are populated
  cron::job::multiple { 'observium':
    jobs => [
      {
        minute      => 33,
        hour        => '*/6',
        command     => '/opt/observium/discovery.php -h all >> /dev/null 2>&1',
        description => 'Run a complete discovery of all devices once every 6 hours',
      },
      {
        minute      => '*/5',
        hour        => '*',
        command     => '/opt/observium/discovery.php -h new >> /dev/null 2>&1',
        description => 'Run automated discovery of newly added devices every 5 minutes',
      },
      {
        minute      => '*/5',
        hour        => '*',
        user        => 'www-data',
        command     => '/opt/observium/poller-wrapper.py >> /dev/null 2>&1',
        description => 'Run multithreaded poller wrapper every 5 minutes',
      },
      {
        minute      => 13,
        hour        => 5,
        command     => '/opt/observium/housekeeping.php -ysel >> /dev/null 2>&1',
        description => 'Run housekeeping script daily for syslog, eventlog and alert log',
      },
      {
        minute      => 47,
        hour        => 4,
        command     => '/opt/observium/housekeeping.php -yrptb >> /dev/null 2>&1',
        description => 'Run housekeeping script daily for rrds, ports, orphaned entries in the database and performance data',
      },
    ],
  }
}

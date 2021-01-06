# Class: observium::apache inherits observium
#
# Configure apache server with virtual host for observium
#
class observium::apache inherits observium {
  assert_private()
  # Declare base apache class
  class { 'apache':
    default_vhost => false,
  }

  apache::vhost { $apache_hostname:
    port            => $apache_port,
    docroot         => '/opt/observium/html/',
    servername      => $apache_hostname,
    access_log_file => '/opt/observium/logs/access_log',
    error_log_file  => '/opt/observium/logs/error_log',
    directories      => [
      { 'path'  => '/opt/observium/html/',
        'Config' => {
          override => 'All',
        }
      },
    ],
  }

}

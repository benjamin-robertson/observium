# Class: observium::apache inherits observium
#
# Configure apache server with virtual host for observium
#
class observium::apache {
  assert_private()

# Declare base apache class
  if $observium::manage_apache {
    class { 'apache':
      default_vhost => false,
    }
  }

# Specify virtual host - check if we are doing ssl or not
if $manage_ssl {
  # We are doing SSL
  apache::vhost { $observium::apache_hostname:
    port            => $observium::apache_sslport,
    docroot         => '/opt/observium/html/',
    servername      => $observium::apache_hostname,
    access_log_file => '/opt/observium/logs/access_log',
    error_log_file  => '/opt/observium/logs/error_log',
    ssl             => true,
    ssl_cert        => '/etc/ssl/observium_cert.pem',
    ssl_key         => '/etc/ssl/observium_key.pem',
    directories     => [
      { 'path'           => '/opt/observium/html/',
        'options'        => 'FollowSymLinks MultiViews',
        'allow_override' => 'All',
        'auth_require'   => 'all granted',
      },
    ],
  }
}
else {
  # We are not doing SSL
  apache::vhost { $observium::apache_hostname:
    port            => $observium::apache_port,
    docroot         => '/opt/observium/html/',
    servername      => $observium::apache_hostname,
    access_log_file => '/opt/observium/logs/access_log',
    error_log_file  => '/opt/observium/logs/error_log',
    directories     => [
      { 'path'           => '/opt/observium/html/',
        'options'        => 'FollowSymLinks MultiViews',
        'allow_override' => 'All',
        'auth_require'   => 'all granted',
      },
    ],
  }
}


# Include php module
  if $observium::manage_apachephp {
    class { 'apache::mod::php':
      php_version => '7',
    }
  }
}

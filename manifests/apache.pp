# Class: observium::apache inherits observium
#
# Configure apache server with virtual host for observium
#
# @api private
#
class observium::apache {
  assert_private()

  # Declare base apache class
  if $observium::manage_apache {
    class { 'apache':
      default_vhost => false,
      mpm_module    => 'prefork',
    }
    if $facts['os']['family'] == 'Debian' {
      include apache::mod::rewrite
    }
  }

  # Specify virtual host - check if we are doing ssl or not
  if $observium::manage_ssl {
    # We are doing SSL
    apache::vhost { $observium::apache_hostname:
      port            => $observium::apache_sslport,
      docroot         => '/opt/observium/html/',
      servername      => $observium::apache_hostname,
      access_log_file => $observium::apache_access_log_file,
      error_log_file  => $observium::apache_error_log_file,
      ssl             => true,
      ssl_cert        => $observium::custom_ssl_cert,
      ssl_key         => $observium::custom_ssl_key,
      directories     => [
        {
          'path'           => '/opt/observium/html/',
          'options'        => 'FollowSymLinks MultiViews',
          'allow_override' => 'All',
          'auth_require'   => $observium::apache_auth_require,
        } + $observium::apache_custom_options,
      ],
    }
  }
  else {
    # We are not doing SSL
    apache::vhost { $observium::apache_hostname:
      port            => $observium::apache_port,
      docroot         => '/opt/observium/html/',
      servername      => $observium::apache_hostname,
      access_log_file => $observium::apache_access_log,
      error_log_file  => $observium::apache_error_log,
      directories     => [
        { 'path'           => '/opt/observium/html/',
          'options'        => 'FollowSymLinks MultiViews',
          'allow_override' => 'All',
          'auth_require'   => 'all granted',
        },
      ],
    }
  }

  # Include php module - old 
  $apache_php_version = lookup(observium::apache_php_version)
  if $observium::manage_apachephp {
    # New way
    class { 'apache::mod::php':
      php_version => $apache_php_version,
    }
  }
}

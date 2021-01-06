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

# Specify virtual host
  apache::vhost { $apache_hostname:
    port            => $apache_port,
    docroot         => '/opt/observium/html/',
    servername      => $apache_hostname,
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

# Include php module
  class { 'apache::mod::php':
    path    => 'modules/libphp7.so',
    content => @(EOT)
#
# PHP is an HTML-embedded scripting language which attempts to make it
# easy for developers to write dynamically generated webpages.
#

# Cannot load both php5 and php7 modules
<IfModule !mod_php5.c>
  <IfModule prefork.c>
    LoadModule php7_module modules/libphp7.so
  </IfModule>
</IfModule>


<IfModule !mod_php5.c>
  <IfModule !prefork.c>
    LoadModule php7_module modules/libphp7-zts.so
  </IfModule>
</IfModule>

    | EOT
  }

}

# @summary
#
# Creates requried yumrepo for RHEL and installs GPG keys.
#
# @api private
#
class observium::yum {
  assert_private()
  # Check if we are managing repo
  if observium::manage_repo {
    # place GPG keys on disk
    $observium::gpgkeys.each |String $gpglocation, Hash $gpghash | {
      file { $gpglocation:
        ensure  => file,
        mode    => '0644',
        content => $gpghash['content'],
      }
    }

    # check what Redhat we are running on
    case $facts['os']['release']['major'] {
      '7': {
        $observium::repos.each | String $reponame, Hash $repoinfo | {
          yumrepo { $reponame:
            *  => $repoinfo,
          }
        }
      }
      '8': {
        # Create repos
        $observium::repos.each | String $reponame, Hash $repoinfo | {
          yumrepo { $reponame:
            *      => $repoinfo,
            before => Exec['Set remi-7.2 as default php provider'],
          }
        }

        # Set remi-7.2 module as default php provider RHEL 8 only
        exec { 'Set remi-7.2 as default php provider':
          command => '/bin/dnf module reset php | /bin/dnf module -y install php:remi-7.2',
          unless  => '/bin/dnf module list php | grep "remi-7.2 \\[e\\]"',
        }
      }
      default: { fail('Unsupported operating system, bailing out!!') }
    }
  }
}

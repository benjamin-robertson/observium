# @summary A short summary of the purpose of this class
#
# Looksup required yum repos from hiera and sends them to the yum puppet module to be created. 
#
# @example
#   include observium::yum
class observium::yum {
  assert_private()
  #$repos = lookup('observium::managed_repos', Array)
  #$repodata = lookup('observium::repos', Hash)
  #$gpgkeys = lookup('observium::gpgkeys', Hash)

  # place GPG keys on disk
  $observium::gpgkeys.each |String $gpglocation, Hash $gpghash | {
    file { $gpglocation:
      ensure  => file,
      mode    => '0644',
      content => $gpghash['content']
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
        before => Exec['/bin/dnf module reset php | /bin/dnf module -y install php:remi-7.2'],
      }
    }

    # Set remi-7.2 module as default php provider RHEL 8 only
    exec { '/bin/dnf module reset php | /bin/dnf module -y install php:remi-7.2':
      unless => '/bin/dnf module list php | grep "remi-7.2 \\[e\\]"',
    }
  }
    default: { fail('Unsupported operating system, bailing out!!') }
  }
}

# @summary A short summary of the purpose of this class
#
# Looksup required yum repos from hiera and sends them to the yum puppet module to be created. 
#
# @example
#   include observium::yum
class observium::yum {
  $repos = lookup('observium::managed_repos', Array)
  $repodata = lookup('observium::repos', Hash)
  $gpgkeys = lookup('observium::gpgkeys', Hash)

  # place GPG keys on disk
  $gpgkeys.each |String $gpglocation, Hash $gpghash | {
    file { $gpglocation:
      ensure  => file,
      mode    => '0644',
      content => $gpghash['content']
    }
    #notify { "Location ${gpglocation} da hash ${gpghash['content']}":}
  }

  # Create repos
  $repodata.each | String $reponame, Hash $repoinfo | {
    if has_key($repoinfo, 'baseurl')  {
      yumrepo { $reponame:
        ensure   => $repoinfo['ensure'],
        enabled  => $repoinfo['enabled'],
        gpgcheck => $repoinfo['gpgcheck'],
        name     => $reponame,
        descr    => $repoinfo['descr'],
        gpgkey   => $repoinfo['gpgkey'],
        target   => $repoinfo['target'],
        baseurl  => $repointo['baseurl'],
      }
    } else {
      yumrepo { $reponame:
        ensure     => $repoinfo['ensure'],
        enabled    => $repoinfo['enabled'],
        gpgcheck   => $repoinfo['gpgcheck'],
        name       => $reponame,
        descr      => $repoinfo['descr'],
        gpgkey     => $repoinfo['gpgkey'],
        target     => $repoinfo['target'],
        mirrorlist => $repoinfo['mirrorlist'],
      }
    }
  }

  #class { 'yum':
  #  managed_repos => $repos,
  #  repos         => $repodata,
    #gpgkeys       => $gpgkeys,
  #}

}

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

  Class { 'yum':
    managed_repos => $repos,
    repos         => $repodata,
    gpgkeys       => $gpgkeys,
  }

  $required_packages = lookup('observium::required_packages', Array)
  package { $required_packages:
    ensure  => 'latest',
    require => 
  }
}

# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include observium
class observium {
  $repos = lookup('observium::managed_repos', Array)
  $repodata = lookup('observium::repos', Hash)
  notify {"repos are ${repos}":}
  notify {"repodata are ${repodata}":}

  Class { 'yum':
    managed_repos => $repos,
    repos         => $repodata,
  }

}

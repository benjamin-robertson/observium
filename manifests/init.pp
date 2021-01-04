# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include observium
class observium {
  $repos = lookup('yum::managed_repos', Array)
  $repodata = lookup('yum::repos', Hash)
  notify {"repos are ${repos}":}
  notify {"repodata are ${repodata}":}
}

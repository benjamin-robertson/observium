# @summary Provisions machines
#
# Provisions machines for integration testing
#
# @example
#   observium::acceptance::provision_integration
plan observium::acceptance::provision_integration(
  Optional[String] $image = 'centos-stream8',
  Optional[String] $provision_type = 'provision_service',
) {
  #provision server machine, set role
  run_task("provision::${provision_type}", 'localhost', action => 'provision', platform => $image, vars => 'role: observium')
}

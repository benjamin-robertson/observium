# Class: observium::
#
# Class disables selinux as per observium install guide.
#
class observium::selinux {
  assert_private()
  # Check if we are managing selinux
  if observium::manage_selinux {
    # disable selinux
    class { 'selinux':
      mode => 'permissive',
      type => 'targeted',
    }
  }
}

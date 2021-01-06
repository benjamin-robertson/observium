# Class: observium::
#
# Class disables selinux as per observium install guide.
#
class observium::selinux {
  assert_private()
  # disable selinux
  class { 'selinux':
    mode => 'permissive',
    type => 'targeted',
  }
}

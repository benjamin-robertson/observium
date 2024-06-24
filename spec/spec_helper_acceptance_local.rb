include PuppetLitmus

def install_packge(package)
  if os[:family] == 'redhat'
    run_shell("yum -y install #{package}")
  elsif os[:family] == 'ubuntu'
    run_shell('apt update')
    run_shell("apt -y install #{package}")
  end
end

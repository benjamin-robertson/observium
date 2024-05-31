include PuppetLitmus

def install_packge(package)
    if os[:family] == 'Ubuntu'
        run_shell("apt -y install #{package}")
    end
    if os[:family] == 'RedHat'
        run_shell("yum -y install #{package}")
    end
    
end
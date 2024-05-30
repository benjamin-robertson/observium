include PuppetLitmus

def install_packge(package)
    if :osfamily == 'Ubuntu'
        run_shell("apt -y install #{package}")
    end
    if :osfamily == 'RedHat'
        run_shell("yum -y install #{package}")
    end
    
end
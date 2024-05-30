include PuppetLitmus

def install_packge(package)
    if :osfamily == 'Ubuntu' do
        run_shell("apt -y install #{package}")
    end
    if :osfamily == 'RedHat' do
        run_shell("yum -y install #{package}")
    end
    
end
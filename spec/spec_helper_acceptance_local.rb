include PuppetLitmus

def install_packge(package)
    run_shell("yum -y install #{package}")
end
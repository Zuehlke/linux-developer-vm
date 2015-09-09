
Vagrant::configure("2") do |config|

  #
  # define the dev-box VM
  #
  config.vm.define :"dev-box2" do | devbox_config |

    # configure the basebox
    devbox_config.vm.box = "boxcutter/ubuntu1404-desktop"

    # hostname
    devbox_config.vm.hostname = "dev-box2.local"

    # virtualbox customizations
    devbox_config.vm.provider :virtualbox do |vbox, override|
      vbox.customize ["modifyvm", :id,
        "--name", "dev-box2",
        "--memory", 512,
        "--cpus", 4
      ]
      # yes we have a gui
      vbox.gui = true
    end

    # TODO
    # - copy cb dir
    # - berkshelf
    # - cat heredoc to update.sh on Desktop
    # - run update.sh
    #
    devbox_config.vm.provision :shell, inline: <<-EOH
      mkdir -p /tmp/vagrant-cache/vagrant_omnibus
      wget -nc -O /tmp/vagrant-cache/vagrant_omnibus/chefdk_0.7.0-1_amd64.deb https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.7.0-1_amd64.deb
      (chef -v | grep 0.7.0) || sudo dpkg -i /tmp/vagrant-cache/vagrant_omnibus/chefdk_0.7.0-1_amd64.deb
      echo "running chef"
      cd /vagrant/cookbooks
      chef-client -z --runlist vm
    EOH
  end
end

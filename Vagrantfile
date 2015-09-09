
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

    # install ChefDK
    devbox_config.vm.provision :shell, path: "scripts/install_chefdk.sh"

    # TODO
    # - copy cb dir
    # - berkshelf
    # - cat heredoc to update.sh on Desktop
    # - run update.sh
    #
    devbox_config.vm.provision :shell, inline: <<-EOH
      echo "running chef"
      cd /vagrant/cookbooks
      chef-client -z --runlist vm
    EOH
  end
end

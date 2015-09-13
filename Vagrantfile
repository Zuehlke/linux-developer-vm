
Vagrant::configure("2") do |config|

  #
  # define the dev-box VM
  #
  config.vm.define :"linux-devbox" do | devbox_config |

    # configure the basebox
    devbox_config.vm.box = "boxcutter/ubuntu1404-desktop"

    # hostname
    devbox_config.vm.hostname = "linux-devbox.local"

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

    # Install ChefDK and trigger the Chef run from within the VM
    devbox_config.vm.provision "shell", privileged: false, inline: "/vagrant/scripts/update-vm.sh"
  end
end

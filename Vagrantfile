
Vagrant::configure("2") do |config|

  #
  # define the Linux developer VM
  #
  config.vm.define :"linux-devbox" do | devbox_config |

    # configure the basebox
    devbox_config.vm.box = "boxcutter/ubuntu1404-desktop"

    # override the basebox when testing (an approximation) with docker
    devbox_config.vm.provider :docker do |docker, override|
      override.vm.box = "tknerr/baseimage-ubuntu-14.04"
    end

    # set the hostname
    devbox_config.vm.hostname = "linux-devbox.local"

    # virtualbox customizations
    devbox_config.vm.provider :virtualbox do |vbox, override|
      vbox.customize ["modifyvm", :id,
        "--name", "linux-devbox",
        "--memory", 512,
        "--cpus", 4
      ]
      # yes we have a gui
      vbox.gui = true
    end

    # Install ChefDK and trigger the Chef run from within the VM
    devbox_config.vm.provision "shell", privileged: false, inline: "/vagrant/scripts/update-vm.sh"

    # Ensure we cache as much as possible
    if Vagrant.has_plugin?("vagrant-cachier")
      devbox_config.cache.enable :generic, {
        "chef_file_cache" => { cache_dir: "/home/vagrant/.chef/local-mode-cache/cache" }
      }
    end
  end
end

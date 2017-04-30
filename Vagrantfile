
Vagrant::configure("2") do |config|

  # configure the basebox
  config.vm.box = "tknerr/ubuntu1604-desktop"
  config.vm.box_version = "2.0.27.1"

  # override the basebox when testing (an approximation) with docker
  config.vm.provider :docker do |docker, override|
    override.vm.box = "tknerr/baseimage-ubuntu-16.04"
    override.vm.box_version = "1.0.0"
  end

  # set the hostname
  config.vm.hostname = "linux-developer-vm.local"

  # virtualbox customizations
  config.vm.provider :virtualbox do |vbox, override|
    vbox.customize ["modifyvm", :id,
      "--name", "Linux Developer VM",
      "--memory", 1048,
      "--cpus", 4
    ]
    # yes we have a gui
    vbox.gui = true
  end

  # Install ChefDK and trigger the Chef run from within the VM
  config.vm.provision "shell", privileged: false, keep_color: true, run: 'always', inline: <<-EOF
    /vagrant/scripts/update-vm.sh #{ENV['UPDATE_VM_FLAGS']}
    EOF

  # Logout any existing GUI session to force the use to re-login, which is required
  # for group or keyboard layout changes to take effect
  config.vm.provision "shell", privileged: true, inline: "pkill -KILL -u vagrant; true"

  # Ensure we cache as much as possible
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.enable :generic, {
      "chef_file_cache" => { cache_dir: "/root/.chef/local-mode-cache/cache" }
    }
  end
end

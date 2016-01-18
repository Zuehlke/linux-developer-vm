
# Linux Developer VM Example

[![Circle CI](https://circleci.com/gh/Zuehlke/linux-developer-vm/tree/master.svg?style=shield)](https://circleci.com/gh/Zuehlke/linux-developer-vm/tree/master)

A minimal example / template project for a Chef-managed Linux developer VM.

![Linux Developer VM Screenshot](https://raw.github.com/Zuehlke/linux-developer-vm/master/linux_devbox.png)

It's meant to be copy/pasted and filled with life. The `cookbooks/vm` directory
contains the recipes for setting up the VM and the tests that come along with it.
All your specific customizations go in there!

Looking for some more concrete / real life examples?

 * https://github.com/tknerr/linus-kitchen
 * https://github.com/Zuehlke/java-developer-vm

## Prerequisites

You only need [VirtualBox](http://virtualbox.org/wiki/Downloads) and [Vagrant](http://www.vagrantup.com/)
installed.

All other requirements, along with ChefDK and Git will be installed *inside the Vagrant VM* during provisioning, i.e. you don't need them installed on your host machine.

## Basic Usage

Bring up the example Linux Developer VM:
```
$ vagrant up
```

This will take a while, as it will do quite a few things inside the VM:

 1. Download and install [Git](https://git-scm.org/) and [ChefDK](https://downloads.chef.io/chef-dk/)
 1. Copy the current directory into the VM (will be placed in `~/vm-setup`)
 1. Install cookbook dependencies via [Berkshelf](http://berkshelf.com/) to `~/vm-setup/cookbooks/vm/cookbooks`
 1. Trigger a [Chef-Zero](https://www.chef.io/blog/2013/10/31/chef-client-z-from-zero-to-chef-in-8-5-seconds/) run to apply the `~/vm-setup/cookbooks/vm/recipes` to the VM (see "What's included?")
 1. Verify the installation using a set of [Serverspec](http://serverspec.org/) tests

Watch the vagrant output on the console for seeing progress. At the end you
should see all tests passing:

```
...
==> default:
==> default: vm::base
==> default:   installs git
==> default:   installs vim
==> default:   places a README on the Desktop
==> default:
==> default: Finished in 0.28206 seconds (files took 1.01 seconds to load)
==> default: 3 examples, 0 failures
...
```

You can now log in to the Desktop (the VM is started in GUI mode):

 * user: "vagrant"
 * password: "vagrant"

Once logged in, you can open a terminal and you will have all of the tools available (see next section).

## What's included?

Only the basic tools, since this is just a minimal developer VM example you should extend on your own:

 * [Git](https://git-scm.org/)
 * [ChefDK](https://downloads.chef.io/chef-dk/)
 * [vim](http://www.vim.org/)

## Updating the Developer VM

Even though you can trigger an update from outside the VM via `vagrant provision`,
you usually want to do that from *inside the VM* as this is your current working environment.
The update is done via Chef so it should be fully idempotent.

You can run these commands from anywhere inside the VM:

* `update-vm` - to apply the Chef recipes of the locally checked out repo in `~/vm-setup`
* `update-vm --pull` - same as above but update the repo before
* `update-vm --verify-only` - don't update the VM, only run the Serverspec tests

## Keyboard Layout

Seems to be too hard to automate for me, so you have to do this manually:
```
sudo dpkg-reconfigure keyboard-configuration
```

## Packaging

Whenever you feel like distributing a fat VM image rather than a Vagrantfile,
you can package / export it as a VirtualBox image. This might be useful
for distributing the initial version of the developer VM to your dev team,
or simply for preserving checkpoint releases as a binary images.

First, start from a clean state, and make sure vagrant-cachier is disabled:
```
$ vagrant destroy -f
$ export VAGRANT_NO_PLUGINS=1
$ vagrant up
```

Next, unmount the /vagrant shared folder (will be restored on next `vagrant up`):
```
$ vagrant ssh -c "sudo umount /vagrant"
```

Also, you may want to clean out the VM for a minimal export image:
```
$ vagrant ssh -c "wget -qO- https://raw.githubusercontent.com/boxcutter/ubuntu/master/script/cleanup.sh | sudo bash"
```

Finally, shutdown the VM, remove the sharedfolder, and export the VM as an .ova file:
```
$ vagrant halt
$ VBoxManage sharedfolder remove "Example Linux Developer VM" --name "vagrant"
$ VBoxManage export "Example Linux Developer VM" --output "linux-devbox.ova" --options manifest,nomacs
```

Don't forget to throw away the VM enable vagrant-cachier again:
```
$ vagrant destroy -f
$ unset VAGRANT_NO_PLUGINS
```

## Contributing

 1. Fork the repository on Github
 1. Create a named feature branch (like `add-xyz`)
 1. Implement your changes, add tests
 1. Commit and push
 1. Submit a Pull Request using Github

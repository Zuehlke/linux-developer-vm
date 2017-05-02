
# Linux Developer VM Example / Template

[![Circle CI](https://circleci.com/gh/Zuehlke/linux-developer-vm/tree/master.svg?style=shield)](https://circleci.com/gh/Zuehlke/linux-developer-vm/tree/master)

A minimal example / template project for a Chef-managed Linux Developer VM.

![Linux Developer VM Screenshot](https://raw.github.com/Zuehlke/linux-developer-vm/master/linux_devbox.png)

It's meant to be copy/pasted and filled with life. The `cookbooks/vm` directory
contains the recipes for setting up the VM and the tests that come along with it.
All your specific customizations go in there!

Looking for some more concrete / real life examples?

 * https://github.com/tknerr/linus-kitchen
 * https://github.com/Zuehlke/java-developer-vm


## What's included?

### Main tools

These are the main tools included in this developer VM (see CHANGELOG for the specific versions):

 * [ChefDK](https://downloads.chef.io/chef-dk/)
 * [Git](https://git-scm.org/)
 * [VIM](http://www.vim.org/)

### Tweaks and Settings

Other tweaks and settings worth mentioning:

 * placed a `README.md` file on the Desktop to guide first time users after they logged in to the VM
 * added an initial `~/.gitconfig` file with a few useful aliases
 * symlinked [`update-vm.sh`](scripts/update-vm.sh) to `/usr/local/bin/update-vm` so it's in the `$PATH` and can be used for updating the VM from the inside (see below)


## Usage

### Obtaining and Starting the VM Image

The latest version of this developer VM can be downloaded as a VM image from here:

 * https://github.com/Zuehlke/linux-developer-vm/releases

After downloading the .ova file you can import it into VirtualBox via `File -> Import Appliance...`.
Once imported, you can simply start the VM and log in:

 * username: "vagrant"
 * password: "vagrant"

From then on just open a terminal and you will have all of the tools available (see "What's included?").

### Updating the VM

You can run these commands from anywhere inside the developer VM:

 * `update-vm` - update the VM by applying the Chef recipes from the locally checked out repo at `~/vm-setup`
 * `update-vm --pull` - same as above, but update repo before by pulling the latest changes
 * `update-vm --verify-only` - don't update the VM, only run the Serverspec tests
 * `update-vm --provision-only` - don't run the Serverspec tests, only update the vm

### Keyboard Layout and Locale Settings

The VM ships with a full `US` keyboard layout and `en_US.UTF-8` locale by default.

To change the keyboard layout to your preferred language use `System Settings... -> Text Entry` in the VM.

If you have a totally different keymap (e.g. on a MacBook) you can always reconfigure it:
```
sudo dpkg-reconfigure keyboard-configuration
```

If want to reconfigure the locale:
```
sudo dpkg-reconfigure locales
```


## Development

### Prerequisites

You only need [VirtualBox](http://virtualbox.org/wiki/Downloads) and [Vagrant](http://www.vagrantup.com/)
installed.

All other requirements, along with ChefDK and Git will be installed *inside the Vagrant VM* during provisioning, i.e. you don't need them installed on your host machine.

### Basic Development Workflow

Bring up the developer VM:
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
==> default: vm::base
==> default:   installs vim
==> default:   places a README on the Desktop
==> default:
==> default: vm::git
==> default:   installs git
==> default:   adds an initial ~/.gitconfig with useful aliases
==> default:
==> default: update-vm.sh
==> default:   installs chefdk 1.3.32
==> default:   symlinks the update-vm script to /usr/local/bin/
==> default:
==> default: Finished in 0.1026 seconds (files took 0.58484 seconds to load)
==> default: 6 examples, 0 failures
```

If these are passing as expected, you can continue developing on the Chef recipes within this repo.
Please don't forget to add a test for each new feature you add (see "Contributing")

### Packaging

Whenever you feel like distributing a fat VM image rather than a Vagrantfile,
you can package / export it as a VirtualBox image. This might be useful
for distributing the initial version of the developer VM to your dev team,
or simply for preserving checkpoint releases as a binary images.

Let's start from a clean state:
```
$ vagrant destroy -f
$ vagrant up
```

This will provision the VM as usual. Once the provisioning succeeded, we will
do a few cleanup steps before packaging the VM.

First, unmount the /vagrant shared folder:
```
$ vagrant ssh -c "sudo umount /vagrant -f"
```

Finally, shutdown the VM, remove the sharedfolder, and export the VM as an .ova file:
```
$ vagrant halt
$ VBoxManage sharedfolder remove "Linux Developer VM" --name "vagrant"
$ VBoxManage modifyvm "Linux Developer VM" --name "Linux Developer VM v0.1.0"
$ VBoxManage export "Linux Developer VM v0.1.0" --output "linux-developer-vm-v0.1.0.ova" --options manifest,nomacs
```

Don't forget to throw away the VM when you are done:
```
$ vagrant destroy -f
```


## Contributing

 1. Fork the repository on Github
 1. Create a named feature branch (like `feature/add-xyz`)
 1. Implement your changes, add tests
 1. Commit and push
 1. Submit a Pull Request via Github

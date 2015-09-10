
# Linux Developer VM Example

A minimal example / template project for a Chef-managed Linux developer VM.

It consists of two main parts:

 * the `update-vm.sh` script, which makes sure that [ChefDK](https://downloads.chef.io/chef-dk/)
   is installed (you need to have Chef and Berkshelf available) and triggers a Chef run.
 * the `cookbooks/vm` cookbook, which contains the recipes to be applied to the VM.
   All your specific customizations go in there!

## Prerequisites

As a developer using the final product (i.e. the resulting developer VM) you
only need a VM host like [VirtualBox](http://virtualbox.org/wiki/Downloads)
installed.

As the guy who will be building and customizing the developer VM you will additionally
need [Vagrant](http://www.vagrantup.com/) and [Ruby](https://www.ruby-lang.org/) installed.

## Usage

In short:

 1. fork it
 2. customize it
 3. package it
 4. run it

### Fork It

Well, that's easy. The "Fork" button is right there...

### Customize It

First, you bring up an isolated VM for testing your changes:
```
$ vagrant up
```

Now it gets a bit more Cheffy. The typical tasks are:

 * add a new recipe to `cookbooks/vm/recipes` and include it in the `default.rb` recipe
 * if you want to reuse existing cookbooks from [the supermarket](https://supermarket.chef.io/),
   add the dependencies to `cookbooks/vm/metadata.rb` so that Berkshelf can resolve it
 * for whatever you do, add a test in `cookbooks/vm/test/integration`

Once you have added some Chef recipes, provision the VM to see it in effect:
```
$ vagrant provision
```

Whenever something is done:
```
$ git add .
$ git commit -m "added awesome new tool to our developer VM"
```

Now rinse and repeat until you have a first version of your customized developer VM ready.


### Package It

Whenever you have a state ready enough for distributing it to your developers,
you can package / export it as a VirtualBox image.

First, start from a clean state:
```
$ vagrant destroy -f
$ vagrant up
```

Now you have to copy the repository from the shared folder into the VM:
```
$ vagrant ssh -c "cp -r /vagrant /home/vagrant/setup"
```

You should also unmount the shared folders now:
```
$ vagrant ssh -c "sudo umount /vagrant"
```

Clean up for a minimal export image:
```
$ vagrant ssh -c "wget -qO- https://raw.githubusercontent.com/boxcutter/ubuntu/master/script/cleanup.sh | sudo bash"
```

Finally, export the VM as an .ova file:
```
$ vagrant halt
$ VBoxManage export dev-box --output "dev-box-v0.1.ova" --options manifest,nomacs
```


### Run It

As a developer using the VM you typically:

 * import the .ova into VirtualBox (File -> Import Appliance...)
 * start th VM and log in using vagrant / vagrant
 * hack on some development stuff

At certain points in time you may want to update the VM:
```
$ cd /home/vagrant/setup
$ git pull
$ scripts/update-vm.sh
```


## Keyboard Layout

Seems to be too hard to automate for me, so you have to do this manually:
```
sudo dpkg-reconfigure keyboard-configuration
```


## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

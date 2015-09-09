
# Dev-Box

Vagrantfile for setting up an Ubuntu Desktop 14.04 development box.

## Prerequisites

You need [VirtualBox](http://virtualbox.org/wiki/Downloads) and [Vagrant](http://www.vagrantup.com/)
installed.

## Usage

Bring up the dev-box VM:
```
$ vagrant up
```

It will take a while until everything is downloaded and installed. Watch the
log output on the console for it to finish.


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

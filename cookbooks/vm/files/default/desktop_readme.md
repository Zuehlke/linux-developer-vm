
# README

A brief guide to walk you through the initial setup of this developer VM

## Initial Keyboard Setup

Configure the keyboard layout and adjust the timezone:

 * System Settings... -> Text Entry
 * System Settings... -> Time & Date

If you have a totally different keymap (e.g. on a MacBook) you can always reconfigure it:
```
sudo dpkg-reconfigure keyboard-configuration
```

## Updating this Developer VM

You can run these commands from anywhere inside this developer VM:

 * `update-vm` - update the VM by applying the Chef recipes from the locally checked out repo at `~/vm-setup`
 * `update-vm --pull` - same as above, but update repo before by pulling the latest changes
 * `update-vm --verify-only` - don't update the VM, only run the Serverspec tests
 * `update-vm --provision-only` - don't run the Serverspec tests, only update the vm

## Getting Started!

Please refer to the separate GETTING_STARTED guide (if available) on how to start
developing with the specific toolchain in this developer VM.

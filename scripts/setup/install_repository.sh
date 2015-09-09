#!/bin/bash

TARGET_DIR="/home/vagrant/setup"
DESKTOP_DIR="/home/vagrant/Desktop"

echo ""
echo "Copying the repository to $TARGET_DIR..."
echo ""

# get a fresh copy of the whole repo
sudo rm -rf $TARGET_DIR
cp -r /vagrant $TARGET_DIR

# clean up unwanted state files
rm -rf $TARGET_DIR/.vagrant

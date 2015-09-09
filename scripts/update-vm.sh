#!/bin/bash

REPO_DIR="/home/vagrant/setup"

echo ""
echo "Updating the VM..."
echo ""

cd $REPO_DIR/cookbooks/vm

# install cookbook dependencies
berks vendor ./cookbooks

# run chef-zero
sudo chef-client --local-mode --format=doc --force-formatter --runlist=vm

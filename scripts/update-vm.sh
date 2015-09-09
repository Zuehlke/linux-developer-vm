#!/bin/bash

REPO_DIR="/home/vagrant/setup"

echo ""
echo "Updating the VM..."
echo ""

cd $REPO_DIR/cookbooks
chef-client -z --runlist vm

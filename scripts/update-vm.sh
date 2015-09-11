#!/bin/bash

CHEFDK_VERSION="0.7.0"
TARGET_DIR="/tmp/vagrant-cache/wget"
SCRIPT_FILE="$(readlink -f ${BASH_SOURCE[0]})"
REPO_ROOT="$(dirname $SCRIPT_FILE)/.."

echo ""
echo "Checking ChefDK..."
echo ""

if [[ $(chef -v | grep $CHEFDK_VERSION) ]]; then
  echo "ChefDK $CHEFDK_VERSION already installed"
else
  echo "Downloading and installing ChefDK $CHEFDK_VERSION"
  mkdir -p $TARGET_DIR
  wget -nc -O $TARGET_DIR/chefdk_$CHEFDK_VERSION-1_amd64.deb \
    https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_$CHEFDK_VERSION-1_amd64.deb
  sudo dpkg -i $TARGET_DIR/chefdk_$CHEFDK_VERSION-1_amd64.deb
fi

echo ""
echo "Symlinking self as 'update-vm'..."

sudo ln -sf $SCRIPT_FILE /usr/local/bin/update-vm

# pull latest changes from Git?
if [[ "$1" == "--pull" ]]; then
  echo ""
  echo "Pulling latest changes from git..."
  echo ""

  cd $REPO_ROOT
  git pull
fi

echo ""
echo "Updating the VM via Chef..."
echo ""

cd $REPO_ROOT/cookbooks/vm

# install cookbook dependencies
berks vendor ./cookbooks

# run chef-zero
sudo chef-client --local-mode --format=doc --force-formatter --runlist=vm

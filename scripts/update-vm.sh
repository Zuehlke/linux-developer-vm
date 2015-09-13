#!/bin/bash

CHEFDK_VERSION="0.7.0"
TARGET_DIR="/tmp/vagrant-cache/wget"
SCRIPT_FILE="$(readlink -f ${BASH_SOURCE[0]})"
REPO_ROOT="$(dirname $SCRIPT_FILE)/.."

big_step() {
  echo ""
  echo "====================================="
  echo ">>>>>> $1"
  echo "====================================="
  echo ""
}
step() {
  echo ""
  echo ">>>>>> $1"
  echo "-------------------------------------"
  echo ""
}

big_step "Checking ChefDK..."

if [[ $(chef -v | grep $CHEFDK_VERSION) ]]; then
  echo "ChefDK $CHEFDK_VERSION already installed"
else
  step "Downloading and installing ChefDK $CHEFDK_VERSION"
  mkdir -p $TARGET_DIR
  wget -nc -O $TARGET_DIR/chefdk_$CHEFDK_VERSION-1_amd64.deb \
    https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_$CHEFDK_VERSION-1_amd64.deb
  sudo dpkg -i $TARGET_DIR/chefdk_$CHEFDK_VERSION-1_amd64.deb
fi


big_step "Symlinking 'update-vm'..."

sudo ln -sf $SCRIPT_FILE /usr/local/bin/update-vm


big_step "Updating the VM via Chef..."

# pull latest changes from Git?
if [[ "$1" == "--pull" ]]; then
  step "Pulling latest changes from git..."
  cd $REPO_ROOT
  git pull
fi

set -e
cd $REPO_ROOT/cookbooks/vm

# init the shell so we have rake and rspec available
step "init the shell"
eval $(chef shell-init bash)

# install cookbook dependencies
step "install cookbook dependencies"
rm -rf ./cookbooks
berks vendor ./cookbooks

# converge the system via chef-zero
step "trigger the chef-zero run"
sudo chef-client --local-mode --format=doc --force-formatter --color --runlist=vm

# run lint checks
step "run codestyle checks"
rubocop . --format progress --format offenses
foodcritic -f any .

# run integration tests
step "run integration tests"
rspec -fd --color -I test/integration test/integration

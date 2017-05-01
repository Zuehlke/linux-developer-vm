#!/bin/bash
set -e -o pipefail

CHEFDK_VERSION="1.3.32"
TARGET_DIR="/tmp/vagrant-cache/wget"
REPO_ROOT="/home/vagrant/vm-setup"

big_step() {
  echo -e "\n=====================================\n>>>>>> $1\n=====================================\n"
}
step() {
  echo -e "\n\n>>>>>> $1\n-------------------------------------\n"
}

setup_chefdk() {
  big_step "Setting up ChefDK..."
  if [[ $(head -n1 /opt/chefdk/version-manifest.txt | grep "chefdk $CHEFDK_VERSION") ]]; then
    echo "ChefDK $CHEFDK_VERSION already installed"
  else
    step "Downloading and installing ChefDK $CHEFDK_VERSION"
    mkdir -p $TARGET_DIR
    local CHEFDK_DEB=chefdk_$CHEFDK_VERSION-1_amd64.deb
    local CHEFDK_URL=https://packages.chef.io/files/current/chefdk/$CHEFDK_VERSION/ubuntu/16.04/$CHEFDK_DEB
    [[ -f $TARGET_DIR/$CHEFDK_DEB ]] || wget --no-verbose -O $TARGET_DIR/$CHEFDK_DEB $CHEFDK_URL
    sudo dpkg -i $TARGET_DIR/$CHEFDK_DEB
  fi
  # initialize the shell, adding ChefDK binaries to the PATH
  eval "$(chef shell-init bash)"
}

copy_repo_and_symlink_self() {
  big_step "Copying repo into the VM..."
  if mountpoint -q /vagrant; then
    sudo rm -rf $REPO_ROOT
    sudo cp -r /vagrant $REPO_ROOT
    sudo chown -R $USER:$USER $REPO_ROOT
    sudo ln -sf $REPO_ROOT/scripts/update-vm.sh /usr/local/bin/update-vm
    echo "Copied repo to $REPO_ROOT and symlinked the 'update-vm' script"
  else
    echo "Skipped because /vagrant not mounted"
  fi
}

update_repo() {
  big_step "Pulling latest changes from git..."
  cd $REPO_ROOT
  git pull
}

update_vm() {
  big_step "Updating the VM via Chef..."
  cd $REPO_ROOT/cookbooks/vm

  step "install cookbook dependencies"
  berks vendor --delete ./cookbooks

  step "update the system via chef-zero"
  sudo -H chef-client --config-option node_path=/root/.chef/nodes --local-mode --format=doc --force-formatter --log_level=warn --color --runlist=vm
}

verify_vm() {
  big_step "Verifying the VM..."
  cd $REPO_ROOT/cookbooks/vm

  step "run foodcritic linting checks"
  foodcritic -f any .

  step "run serverspec integration tests"
  rspec --require rspec_junit_formatter --format doc --color --tty --format RspecJunitFormatter --out test/junit-report.xml --format html --out test/test-report.html
}

#
# main flow
#
setup_chefdk
if [[ "$1" == "--verify-only" ]]; then
  verify_vm
else
  copy_repo_and_symlink_self
  [[ "$1" == "--pull" ]] && update_repo
  update_vm
  [[ "$1" == "--provision-only" ]] || verify_vm
fi

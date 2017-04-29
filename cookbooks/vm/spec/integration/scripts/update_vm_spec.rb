require 'spec_helper'

describe 'update-vm.sh' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html

  it 'installs git' do
    expect(package('git')).to be_installed
    expect(command('git --version').exit_status).to eq 0
  end

  it 'installs chefdk 1.3.32' do
    expect(command('chef --version').stdout).to contain 'Chef Development Kit Version: 1.3.32'
  end

  it 'does not leave any root owned files under the user\'s home directory' do
    expect(command('find /home/vagrant -type d -maxdepth 1 -user root').stdout).to be_empty
  end
end

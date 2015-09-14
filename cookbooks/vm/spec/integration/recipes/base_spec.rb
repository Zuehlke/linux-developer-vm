require 'spec_helper'

describe 'vm::base' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html

  it 'installs git' do
    expect(package('git')).to be_installed
    expect(command('git --version').exit_status).to eq 0
  end

  it 'installs vim' do
    expect(package('vim')).to be_installed
    expect(command('vim --version').exit_status).to eq 0
  end

  it 'places a README on the Desktop' do
    expect(file('/home/vagrant/Desktop/README')).to exist
  end
end

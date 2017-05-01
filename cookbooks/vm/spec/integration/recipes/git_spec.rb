require 'spec_helper'

describe 'vm::git' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html

  it 'installs git' do
    expect(package('git')).to be_installed
    expect(command('git --version').exit_status).to eq 0
  end
end

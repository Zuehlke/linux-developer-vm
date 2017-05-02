require 'spec_helper'

describe 'vm::vim' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html

  it 'installs Vi IMproved' do
    expect(package('vim')).to be_installed
    expect(command('vim --version').exit_status).to eq 0
  end
end

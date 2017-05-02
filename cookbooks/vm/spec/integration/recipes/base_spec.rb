require 'spec_helper'

describe 'vm::base' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html

  it 'places a README on the Desktop' do
    expect(file('/home/vagrant/Desktop/README.md')).to exist
  end
end

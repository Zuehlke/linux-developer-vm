
include_recipe 'apt'

# base packages
package 'vim' do
  action :install
end#

# create a README on the Desktop
directory '/home/vagrant/Desktop' do
  owner 'vagrant'
  group 'vagrant'
  mode '0755'
end
cookbook_file '/home/vagrant/Desktop/README.md' do
  source "desktop_readme.md"
  owner 'vagrant'
  group 'vagrant'
  mode '0644'
end

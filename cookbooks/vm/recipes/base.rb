
# update the apt cache
include_recipe 'apt'

# place a README on the Desktop
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

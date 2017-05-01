
# install git
package 'git' do
  action :install
end

# create an initial .gitconfig
cookbook_file "/home/vagrant/.gitconfig" do
  source 'git_config'
  owner 'vagrant'
  group 'vagrant'
  mode '0644'
  action :create_if_missing
end

#
# Cookbook Name:: vm
# Recipe:: base - minimum installation we need for every developer VM
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#

include_recipe 'apt'

package 'vim' do
  action :install
end

package 'git' do
  action :install
end

file '/home/vagrant/Desktop/README' do
  owner 'vagrant'
  group 'vagrant'
  mode '0644'
  action :create
  content <<-EOF
Developer VM README
===================

For applying the current configuration to the VM:

  * simply run `update-vm`

For updating to the latest configuration and applying that:

  * simply run `update-vm --pull`

For verifying the current configuration without applying anything:

  * simply run `update-vm --verify-only`
EOF
end

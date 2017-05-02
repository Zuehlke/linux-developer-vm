#
# return a minimal sane environment for the vm user to be used in bash resources
# see https://tickets.opscode.com/browse/CHEF-2288
#
def vm_user_env
  {
    'HOME' => vm_user_home,
    'USER' => vm_user
  }
end

#
# return the VM user under which the provisioning is running
#
def vm_user
  ENV['SUDO_USER']
end

#
# return the VM user's group (same as user currently)
#
def vm_group
  vm_user
end

#
# return the VM user's home directory
#
def vm_user_home
  "/home/#{vm_user}"
end

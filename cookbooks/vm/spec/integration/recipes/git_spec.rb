require 'spec_helper'

describe 'vm::git' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html

  it 'installs git' do
    expect(package('git')).to be_installed
    expect(command('git --version').exit_status).to eq 0
  end

  it 'adds an initial ~/.gitconfig with useful aliases' do
    expect(file('/home/vagrant/.gitconfig')).to exist
    expect(command('git config --global --list | sort').stdout).to contain <<~EOF
      alias.br=branch
      alias.ci=commit
      alias.co=checkout
      alias.graph=log --all --oneline --graph --decorate
      alias.slog=log --pretty=oneline --abbrev-commit
      alias.st=status
      alias.unstage=reset HEAD --
      EOF
  end
end

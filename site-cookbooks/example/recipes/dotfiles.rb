#
# Cookbook Name:: example
# Recipe:: dotfiles
#
# Copyright 2014, kimikimi714
#
# All rights reserved - Do Not Redistribute
#

VAGRANT_HOME = node[:etc][:passwd][:vagrant][:dir]

# download dotfiles
git VAGRANT_HOME + '/dotfiles' do
  repository 'https://github.com/kimikimi714/config.git'
  reference 'master'
  action :sync
  user 'vagrant'
  group 'vagrant'
end

# setup gitconfig
template "gitconfig" do
  path   VAGRANT_HOME + '/dotfiles/.gitconfig'
  source "gitconfig.erb"
  owner  'vagrant'
  group  'vagrant'
end

link "gitconfig" do
  target_file VAGRANT_HOME + '/.gitconfig'
  to          VAGRANT_HOME + '/dotfiles/.gitconfig'
  only_if {File.exists?(VAGRANT_HOME + '/dotfiles/.gitconfig')}
end
#
# Cookbook Name:: example
# Recipe:: ruby
#
# Copyright 2014, kimikimi714
#
# All rights reserved - Do Not Redistribute
#

include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"

include_recipe "rbenv::rbenv_vars"

rbenv_ruby "2.0.0-p481" do
  ruby_version "2.1.1"
  global true
end

rbenv_gem "bundler" do
    ruby_version "2.0.0-p481"
end


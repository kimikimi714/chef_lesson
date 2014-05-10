#
# Cookbook Name:: docker
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "docker.io" do
    action :install
end

link "docker" do
    target_file '/usr/local/bin/docker'
    to          '/usr/bin/docker.io'
    only_if {File.exists?('/usr/bin/docker.io')}
end
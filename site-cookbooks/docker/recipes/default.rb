#
# Cookbook Name:: docker
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

##################################################################
### clock settings
##################################################################
template "clock" do
  path "/etc/timezone"
  source "timezone.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :run, 'bash[clock_settings]'
  only_if {File.exists?("/usr/share/zoneinfo/Asia/Tokyo")}
end

bash "clock_settings" do
  user "root"
  code <<-EOH
    dpkg-reconfigure --frontend noninteractive tzdata
  EOH
  only_if {File.exists?("/etc/timezone")}
end

# docker install
package "docker.io" do
    action :install
end

link "docker" do
    target_file '/usr/local/bin/docker'
    to          '/usr/bin/docker.io'
    only_if {File.exists?('/usr/bin/docker.io')}
end
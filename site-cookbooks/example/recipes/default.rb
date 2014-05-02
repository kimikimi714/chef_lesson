#
# Cookbook Name:: example
# Recipe:: default
#
# Copyright 2014, kimikimi714
#
# All rights reserved - Do Not Redistribute
#

##################################################################
### clock settings
##################################################################
template "clock" do
  path "/etc/sysconfig/clock"
  source "clock.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :run, 'bash[clock_settings]'
  only_if {File.exists?("/usr/share/zoneinfo/Asia/Tokyo")}
end

bash "clock_settings" do
  user "root"
  code <<-EOH
    source /etc/sysconfig/clock
    cp -p /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
  EOH
  only_if {File.exists?("/usr/share/zoneinfo/Asia/Tokyo")}
end

##################################################################
### repository settings
##################################################################
package "yum" do
  action :upgrade
end

# add epel, remi repositories
yum_repository 'epel' do
  description 'Extra Packages for Enterprise Linux'
  mirrorlist 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch'
  fastestmirror_enabled true
  gpgkey 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
  action :create
end

yum_repository 'remi' do
  description 'Les RPM de Remi - Repository'
  baseurl 'http://rpms.famillecollet.com/enterprise/6/remi/x86_64/'
  gpgkey 'http://rpms.famillecollet.com/RPM-GPG-KEY-remi'
  fastestmirror_enabled true
  action :create
end

##################################################################
### common components
##################################################################
%w{
  git-core
  vim-enhanced
}.each do |p|
  package p do
    action :install
  end
end

# iptables
service "iptables" do
  only_if {
    File.exists? "/etc/sysconfig/iptables"
  }
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

template "iptables" do
  path "/etc/sysconfig/iptables"
  source "iptables.erb"
  owner "root"
  group "root"
  mode 0600
  notifies :restart, 'service[iptables]'
end


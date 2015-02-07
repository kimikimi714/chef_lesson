#
# Cookbook Name:: example
# Recipe:: default
#
# Copyright 2014, kimikimi714
#
# All rights reserved - Do Not Redistribute
#

##################################################################
### dependencies of cookbooks
##################################################################
include_recipe 'cron::default'
include_recipe 'ntp::default'

##################################################################
### clock settings
##################################################################
log("tz-info(before): #{Time.now.strftime("%z %Z")}")

service 'crond'

link '/etc/localtime' do
  to '/usr/share/zoneinfo/Asia/Tokyo'
  notifies :restart, 'service[crond]', :immediately
  only_if {File.exists?('/usr/share/zoneinfo/Asia/Tokyo')}
end

log("tz-info(after): #{Time.now.strftime("%z %Z")}")

##################################################################
### repository settings
##################################################################
package 'yum' do
  action :upgrade
end

# add remi repositories
yum_repository 'remi' do
  description 'Les RPM de Remi - Repository'
  baseurl 'http://rpms.famillecollet.com/enterprise/7/remi/x86_64/'
  gpgkey 'http://rpms.famillecollet.com/RPM-GPG-KEY-remi'
  fastestmirror_enabled true
  action :create
end

##################################################################
### common components
##################################################################
%w{
  svn
  vim-enhanced
  iptables-services
}.each do |p|
  package p do
    action :install
  end
end

# iptables
service 'firewalld' do
  supports :status => false, :restart => false, :reload => false
  action [:disable, :stop]
end

service 'iptables' do
  only_if {
    File.exists? '/etc/sysconfig/iptables'
  }
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

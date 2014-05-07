#
# Cookbook Name:: example
# Recipe:: apache
#
# Copyright 2014, kimikimi714
#
# All rights reserved - Do Not Redistribute
#
%w{httpd httpd-devel}.each do |p|
  package p do
    action :install
  end
end

service "httpd" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

# templates
template "httpd.conf" do
  path "/etc/httpd/conf/httpd.conf"
  source "httpd.conf.erb"
  mode 0644
  notifies :restart, 'service[httpd]'
end

directory "/home/vagrant/public_html" do
  owner "vagrant"
  group "vagrant"
  mode 00755
  action :create
  only_if {File.exists?(node[:etc][:passwd][:vagrant][:dir])}
end

template "vagrant.conf" do
  path "/etc/httpd/conf.d/vagrant.conf"
  source "vagrant.conf.erb"
  mode 0644
  notifies :restart, 'service[httpd]'
  only_if {File.exists?(node[:etc][:passwd][:vagrant][:dir] + '/public_html')}
end

template "index.html" do
  path node[:etc][:passwd][:vagrant][:dir] + "/public_html/index.html"
  source "index.html.erb"
  mode 0644
  only_if {File.exists?(node[:etc][:passwd][:vagrant][:dir] + '/public_html')}
end

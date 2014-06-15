#
# Cookbook Name:: example
# Recipe:: database
#
# Copyright 2014, kimikimi714
#
# All rights reserved - Do Not Redistribute
#

%w{
  mysql-server
  memcached
  sqlite
  sqlite-devel
}.each do |p|
  package p do
    action :install
  end
end

##################################################################
### Other services
##################################################################
service "mysqld" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

service "memcached" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

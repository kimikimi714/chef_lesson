#
# Cookbook Name:: set-up
# Recipe:: default
#
# Copyright 2014, kimikimi714
#
# All rights reserved - Do Not Redistribute
#

### epel remi
package "yum" do
  action :upgrade
end

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
### install
##################################################################
%w{
  httpd
  httpd-devel
  mysql-server
  memcached
  subversion
  git-core
  vim-enhanced
  php-pear
}.each do |p|
  package p do
    action :install
  end
end

bash "upgrade_pear" do
  user "root"
  code <<-EOH
    pear channel-discover pear.phpunit.de
    pear channel-discover pear.symfony-project.com
    pear channel-update pear.php.net
    pear channel-discover components.ez.no
    pear upgrade pear
    pear config-set auto_discover 1
  EOH
end

bash "install_HTTP_Request2" do
  user "root"
  code "pear install HTTP_Request2"
  not_if { ::File.exists?("/usr/share/pear/HTTP/Request2.php")}
end

bash "install_xml_serializer" do
  user "root"
  code "pear install --alldeps xml_serializer-beta"
  not_if { ::File.exists?("/usr/share/pear/XML/Serializer.php")}
end

bash "install_phpunit" do
  user "root"
  code <<-EOH
    pear install pear.phpunit.de/PHPUnit
    pear install --alldeps phpunit/PHP_CodeCoverage
  EOH
  not_if { ::File.exists?("/usr/bin/phpunit")}
end

bash "install_jenkins" do
  user "root"
  code <<-EOH
    yum -y install java-1.7.0-openjdk.x86_64
    wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
    rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
    yum -y install jenkins
  EOH
  not_if { ::File.exists?("/usr/bin/jenkins")}
end

%w{
  php-mysql
  php-pecl-memcache
  php-dom
  php
  php-devel
  php-mbstring
  php-mcrypt
}.each do |p|
  package p do
    action :install
  end
end

##################################################################
### services
##################################################################
service "iptables" do
  only_if {
    File.exists? "/etc/sysconfig/iptables"
  }
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end
service "httpd" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

##################################################################
### templates
##################################################################
template "php.ini" do
  path "/etc/php.ini"
  source "php.ini.erb"
  mode 0644
end

template "httpd.conf" do
  path "/etc/httpd/conf/httpd.conf"
  source "httpd.conf.erb"
  mode 0644
  notifies :restart, 'service[httpd]'
end

template "iptables" do
  path "/etc/sysconfig/iptables"
  source "iptables.erb"
  owner "root"
  group "root"
  mode 0600
  notifies :restart, 'service[iptables]'
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

service "jenkins" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end


# Cookbook Name:: example
# Recipe:: jenkins
#
# Copyright 2014, kimikimi714
#
# All rights reserved - Do Not Redistribute
#

# remove java which has already installed
package 'java' do
  action :remove
end

# install OpenJDK from EPEL repository
package 'java-1.7.0-openjdk' do
  options "--enablerepo=epel"
  action :install
end

# add jenkins repository
yum_repository 'jenkins' do
  description 'RedHat Linux RPM packages for Jenkins'
  baseurl 'http://pkg.jenkins-ci.org/redhat/'
  gpgkey 'http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key'
  fastestmirror_enabled true
  action :create
end

# install jenkins from jenkins repo
package 'jenkins' do
  options "--enablerepo=jenkins"
  action :install
end

service "jenkins" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

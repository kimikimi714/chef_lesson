#
# Cookbook Name:: example
# Recipe:: php
#
# Copyright 2014, kimikimi714
#
# All rights reserved - Do Not Redistribute
#

package 'php-pear' do
  action :install
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

%w{
  php
  php-devel
  php-dom
  php-pecl-memcached
  php-mbstring
  php-mcrypt
}.each do |p|
  package p do
    action :install
  end
end

# templates
template "php.ini" do
  path "/etc/php.ini"
  source "php.ini.erb"
  mode 0644
end

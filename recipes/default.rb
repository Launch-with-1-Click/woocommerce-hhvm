#
# Cookbook Name:: amimoto
# Recipe:: default
#
# Copyright 2013, DigitalCube Co. Ltd.
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'amimoto::timezone'
include_recipe 'amimoto::iptables'
include_recipe 'amimoto::sysctl'
include_recipe 'amimoto::repos'
template "/etc/sysconfig/i18n" do
  source "i18n.erb"
end
#template "/etc/sudoers" do
#  source "sudoers.erb"
#end

%w{ zip unzip wget git openssl bash }.each do | pkg |
  package pkg do
    action [:install, :upgrade]
  end
end

%w{httpd24 httpd24-tools}.each do | pkg |
  package pkg do
    action [:remove]
  end
end

# install mysql
include_recipe 'amimoto::mysql'

# install nginx
include_recipe 'amimoto::nginx'
#include_recipe 'amimoto::nginx_default'

# install php
if node[:hhvm][:enabled]
  include_recipe 'amimoto::hhvm'
else
  include_recipe 'amimoto::php'
end

if (node.memory.total.to_i / 1024) > 1024
  # memcached install
  if node[:memcached][:enabled]
    include_recipe 'amimoto::memcached'
  end

  # redis install
  if node[:redis][:enabled]
    include_recipe 'amimoto::redis'
  end
end

# install monit
include_recipe 'amimoto::monit'

# install wp-cli
include_recipe 'amimoto::wpcli'

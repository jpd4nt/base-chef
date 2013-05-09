#
# Cookbook Name:: base-chef
# Recipe:: default
#
# Copyright 2012, National Theatre
#
# All rights reserved - Do Not Redistribute
#
include_recipe "cron"

# Fix for redhat on AWS that sub manager is broke on AWS
if node['platform'] == "redhat" and node['platform_version'] > '6.0'
  cookbook_file '/etc/yum/pluginconf.d/subscription-manager.conf' do
    source "subscription-manager.conf"
    owner  "root"
    group  "root"
    mode   "0644"
  end
  include_recipe "yum::epel"
end

package "monit" do
  action :install
end

service "monit" do
  supports [:restart, :reload, :status]
  action :enable
end

cron_d "chef-client" do
  minute "*/15"
  command "chef-client -c /etc/chef/client.rb"
  user "root"
end

cookbook_file '/etc/init.d/chef_client' do
  source "chef_client"
  owner  "root"
  group  "root"
  mode   "0755"
end
service "chef_client" do
  action [ :enable, :start ]
end

case node['platform_family']
when "rhel", "fedora"
    execute "yum_update" do
      command "/usr/bin/yum -y update"
    end
when "suse"
  execute "zypper_update" do
    command "/usr/bin/zypper -n up"
  end
when "debian"
  execute "apt_update" do
    command "/usr/bin/apt-get -y upgrade"
  end
end
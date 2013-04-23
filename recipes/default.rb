#
# Cookbook Name:: base-chef
# Recipe:: default
#
# Copyright 2012, National Theatre
#
# All rights reserved - Do Not Redistribute
#
include_recipe "cron"

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
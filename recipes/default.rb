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
  variables()
end
service "chef_client" do
  action [ :enable, :start ]
end
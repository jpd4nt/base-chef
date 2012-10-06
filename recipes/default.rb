#
# Cookbook Name:: base-chef
# Recipe:: default
#
# Copyright 2012, National Theatre
#
# All rights reserved - Do Not Redistribute
#

cron_d "chef-client" do
  minute "*/15"
  command "chef-client -c /etc/chef/client.rb -j /etc/chef/dna.json"
  user "root"
end
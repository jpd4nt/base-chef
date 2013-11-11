#
# Cookbook Name:: base-chef
# Recipe:: newrelic
#
# Copyright 2012, National Theatre
#
# All rights reserved - Do Not Redistribute
#
package "python" do
  action :install
end

case node['platform_family']
when "rhel", "fedora"
    execute "get_pip" do
      command "curl https://raw.github.com/pypa/pip/master/contrib/get-pip.py | python"
    end
end

execute "pip_install_plugin" do
    command "pip install newrelic-plugin-agent"
end

case node['platform_family']
when "rhel", "fedora"
    execute "copy_plugin" do 
        command "cp /etc/init.d/newrelic_plugin_agent.rhel /etc/init.d/newrelic_plugin_agent"
	not_if { ::File.exists?("/etc/init.d/newrelic_plugin_agent")}
    end
when "debian", "ubuntu" 
    execute "copy_plugin" do
        command "cp /etc/init.d/newrelic_plugin_agent.deb /etc/init.d/newrelic_plugin_agent"
        not_if { ::File.exists?("/etc/init.d/newrelic_plugin_agent")}
    end
end

file "/etc/init.d/newrelic_plugin_agent" do
    mode "755"
end

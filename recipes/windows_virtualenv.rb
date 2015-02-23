# Author:: Kourosh Parsa <kouroshtheking@gmail.com>
# Cookbook Name:: python
# Recipe:: windows_virtualenv
#
# Copyright 2015
# All rights reserved
# This recipe installs virtualenv on windows
#

default['python']['virtualenv_location']

ez_setup_path = "#{Chef::Config[:file_cache_path]}\\ez_setup.py"
remote_file ez_setup_path do
  source node['python']['pip']
  not_if do ::File.exist?("#{Chef::Config[:file_cache_path]}\\#{ez_setup_path}") end
end

batch "install virtualenv" do
  code "#{node['python']['pip_location']} install virtualenv"
  not_if do ::File.exist?("#{node['python']['home']}\\Scripts\\virtualenv.exe") end
end
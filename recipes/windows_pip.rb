# Author:: Kourosh Parsa <kouroshtheking@gmail.com>
# Cookbook Name:: python
# Recipe:: windows_pip
#
# Copyright 2015
# All rights reserved
# This recipe installs ez_install and pip on windows
#

ez_setup_path = "#{Chef::Config[:file_cache_path]}\\ez_setup.py"
remote_file ez_setup_path do
  source node['python']['ez_setup']
  not_if do ::File.exist?("#{Chef::Config[:file_cache_path]}\\#{ez_setup_path}") end
end

batch "install easy_install" do
  code "#{node['python']['binary']} #{ez_setup_path}"
  not_if do ::File.exist?(node['python']['easy_install']) end
end

windows_path "#{node['python']['home']}\\Scripts" do
  action :add
end

batch "install pip" do
  code "#{node['python']['easy_install']} pip"
  not_if do ::File.exist?(node['python']['pip_location']) end
end
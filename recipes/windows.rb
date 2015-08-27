# Author:: Kourosh Parsa <kouroshtheking@gmail.com>
# Cookbook Name:: python
# Recipe:: windows
#
# Copyright 2015
# All rights reserved
# This recipe installs python on windows
#
def is_windows_64bit?
  ENV['PROCESSOR_ARCHITECTURE'].include?("64")
end

version = node['python']['version']
bitness = ''
if is_windows_64bit?
  bitness = '.amd64'
end

bin_name = "python-#{version}#{bitness}.msi"
download_path = "#{Chef::Config[:file_cache_path]}\\#{bin_name}"

windows_package 'Install Python' do
  source "#{node['python']['url']}/#{version}/#{bin_name}"
  action :install
  not_if do ::File.exist?(node['python']['home']) end
end

windows_path node['python']['home'] do
  action :add
end


#
# Author:: Seth Chisamore <schisamo@opscode.com>
# Cookbook Name:: python
# Recipe:: pip
#
# Copyright 2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Where does pip get installed?
# platform/method: path (proof)
# redhat/package: /usr/bin/pip (sha a8a3a3)
# omnibus/source: /opt/local/bin/pip (sha 29ce9874)

pip_binary = node['python']['pip_location']

cookbook_file "#{Chef::Config[:file_cache_path]}/ez_setup.py" do
  source 'ez_setup.py'
  mode "0644"
  not_if "#{node['python']['binary']} -c 'import setuptools'"
end

cookbook_file "#{Chef::Config[:file_cache_path]}/get-pip.py" do
  source 'get-pip.py'
  mode "0644"
  not_if { ::File.exists?(pip_binary) }
end

execute "install-setuptools" do
  cwd Chef::Config[:file_cache_path]
  command <<-EOF
  #{node['python']['binary']} ez_setup.py
  EOF
  not_if "#{node['python']['binary']} -c 'import setuptools'"
end

execute "install-pip" do
  cwd Chef::Config[:file_cache_path]
  command <<-EOF
  #{node['python']['binary']} get-pip.py
  EOF
  not_if { ::File.exists?(pip_binary) }
end

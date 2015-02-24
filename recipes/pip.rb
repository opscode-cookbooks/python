#
# Authors:: Seth Chisamore <schisamo@chef.io>, Kourosh Parsa <kouroshtheking@gmail.com>
# Cookbook Name:: python
# Recipe:: pip
#
# Copyright 2011, Chef Software, Inc.
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

cookbook_file "#{Chef::Config[:file_cache_path]}/get-pip.py" do
  source 'get-pip.py'
  mode "0644"
  not_if { ::File.exists?(node['python']['pip']) }
end

execute "install-pip" do
  cwd Chef::Config[:file_cache_path]
  command <<-EOF
  #{node['python']['binary']} get-pip.py
  EOF
  not_if { ::File.exists?(node['python']['pip']) }
end

python_pip 'setuptools' do
  action :upgrade
  version node['python']['setuptools_version']
end

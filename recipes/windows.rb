#
# Author:: Shawn Neal <sneal@daptiv.com>
# Cookbook Name:: python
# Recipe:: windows
#
# Copyright 2014, Daptiv Solutions LLC.
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

version = node['python']['version']

windows_package "Python #{version}" do
  action :install
  source "#{node['python']['url']}/#{version}/#{node['python']['msi_filename']}"
  checksum node['python']['checksum']
  options 'ALLUSERS=1' #Workaround for http://bugs.python.org/issue16188
  installer_type :msi
end

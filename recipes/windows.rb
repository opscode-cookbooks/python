#
# Author:: Shawn Neal <sneal@daptiv.com>
# Cookbook Name:: python
# Recipe:: windows
#
# Copyright 2013, Opscode, Inc.
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

checksum = node['python']['checksum']
version = node['python']['version']

if node['kernel']['machine'] =~ /x86_64/
  msi_file_name = "python-#{version}.amd64.msi"
else
  msi_file_name = "python-#{version}.msi"
end

package_name = "Python #{version}"
url = "#{node['python']['url']}/#{version}/#{msi_file_name}"

windows_package package_name do
  action :install
  source url
  checksum checksum
  options 'ALLUSERS=1' #Workaround for http://bugs.python.org/issue16188
  installer_type :msi
end

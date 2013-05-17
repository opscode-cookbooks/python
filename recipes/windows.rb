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

msi_checksum = node['python']['checksum']
version = node['python']['version']

is_64_bit = ENV.has_key?('ProgramFiles(x86)')
msi_file_name = "python-#{version}.amd64.msi" if is_64_bit
msi_file_name = "python-#{version}.msi" unless is_64_bit

msi_url = "#{node['python']['url']}/#{version}/#{msi_file_name}"
msi_local = cached_file(msi_url, msi_checksum)

windows_package "Python #{version}" do
  action :install
  source msi_local
  checksum msi_checksum
  options 'ALLUSERS=1' #Workaround for http://bugs.python.org/issue16188
  installer_type :msi
end

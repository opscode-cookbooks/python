#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: python
# Attribute:: default
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

default['python']['url'] = 'http://www.python.org/ftp/python'
default['python']['version'] = '2.7.5'

if platform?('windows')
  default['python']['install_method'] = 'windows'
  
  default['python']['binary_dir'] = 'c:/Python27'
  
  default['python']['pip_location'] = "#{node['python']['binary_dir']}/Scripts/pip.exe"
  default['python']['virtualenv_location'] = "#{node['python']['binary_dir']}/Scripts/virtualenv.exe"
  
  if node['kernel']['machine'] =~ /x86_64/
    default['python']['msi_filename'] = "python-#{node['python']['version']}.amd64.msi"
    default['python']['checksum'] = 'cec70fb80feb742b29a5daf6dfd3559c3bc18539baccdeba78ad0b80802d1059'
  else
    default['python']['msi_filename'] = "python-#{node['python']['version']}.msi"
    default['python']['checksum'] = 'ccc5e024e79f5783118a5286a9a5dbb211c194aecb66fbf47e01295394de093b'
  end
else
  default['python']['install_method'] = 'package'

  if python['install_method'] == 'package'
    case platform
    when "smartos"
      default['python']['prefix_dir'] = '/opt/local'
    else
      default['python']['prefix_dir'] = '/usr'
    end
  else
    default['python']['prefix_dir'] = '/usr/local'
  end
  
  default['python']['binary_dir'] = "#{node['python']['prefix_dir']}/bin"
  
  default['python']['pip_location'] = "#{node['python']['binary_dir']}/pip"
  default['python']['virtualenv_location'] = "#{node['python']['binary_dir']}/virtualenv"
  
  default['python']['configure_options'] = %W{--prefix=#{python['prefix_dir']}}
  default['python']['make_options'] = %W{install}
  default['python']['checksum'] = '3b477554864e616a041ee4d7cef9849751770bc7c39adaf78a94ea145c488059'
end

default['python']['binary'] = "#{node['python']['binary_dir']}/python"

#
# Author:: Seth Chisamore (<schisamo@chef.io>)
# Cookbook Name:: python
# Attribute:: default
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

default['python']['install_method'] = 'package'

if python['install_method'] == 'package'
  case platform
  when "smartos"
    default['python']['prefix_dir']         = '/opt/local'
  else
    default['python']['prefix_dir']         = '/usr'
  end
else
  default['python']['prefix_dir']         = '/usr/local'
end

default['python']['url'] = 'http://www.python.org/ftp/python'
default['python']['version'] = '2.7.7'
default['python']['checksum'] = '7f49c0a6705ad89d925181e27d0aaa025ee4731ce0de64776c722216c3e66c42'
default['python']['configure_options'] = %W{--prefix=#{node['python']['prefix_dir']}}
default['python']['make_options'] = %W{install}

default['python']['setuptools_version'] = nil # defaults to latest
default['python']['virtualenv_version'] = nil

ver = default['python']['version']

# Where does pip get installed?
# platform/method: path (proof)
# redhat/package: /usr/bin/pip (sha a8a3a3)
# omnibus/source: /opt/local/bin/pip (sha 29ce9874)
# windows C:\Python27\Scripts\pip.exe

if platform_family?("windows")
  default['python']['home'] = "#{ENV['SYSTEMDRIVE']}\\Python#{ver.split('.')[0..1].join('')}"
  default['python']['easy_install'] = "#{node['python']['home']}\\Scripts\\easy_install.exe"
  default['python']['binary'] = "#{node['python']['home']}/python.exe"
  default['python']['pip'] = "#{node['python']['home']}\\Scripts\\pip.exe"
  default['python']['virtualenv_location'] = "#{node['python']['home']}\\Scripts\\virtualenv"
else
  default['python']['binary'] = "#{node['python']['prefix_dir']}/bin/python"
  default['python']['virtualenv_location'] = "#{node['python']['prefix_dir']}/bin/virtualenv"

  default['python']['pip'] = "#{node['python']['prefix_dir']}/bin/pip"
  if node['python']['install_method'] == 'source'
    default['python']['pip'] = "#{node['python']['prefix_dir']}/bin/pip"
  elsif platform_family?("rhel", "fedora")
    default['python']['pip'] = "/usr/bin/pip"
  elsif platform_family?("smartos")
    default['python']['pip'] = "/opt/local/bin/pip"
  else
    default['python']['pip'] = "/usr/local/bin/pip"
  end
end
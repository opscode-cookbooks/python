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

default['python']['binary_name']          = 'python'
default['python']['install_method'] = 'package'
major_version = platform_version.split('.').first.to_i
if python['install_method'] == 'package'
  default['python']['prefix_dir']         = '/usr'
  case platform
    when "debian"
      default['python']['python_pkgs']        = ["python","python-dev"]
    when "rhel"
      if major_version < 6
        default['python']['binary_name']          = 'python26'
        default['python']['python_pkgs']      = ["python26", "python26-devel"]
      else
        default['python']['python_pkgs']      = ["python","python-devel"]
      end
    when "freebsd"
      default['python']['python_pkgs']        = ["python"]
    when "smartos"
      default['python']['prefix_dir']         = '/opt/local'
      default['python']['python_pkgs']        = ["python27"]
    else
      default['python']['python_pkgs']        = ["python","python-dev"]
  end

else
  default['python']['prefix_dir']         = '/usr/local'
end

default['python']['url'] = 'http://www.python.org/ftp/python'
default['python']['version'] = '2.7.5'
default['python']['checksum'] = '3b477554864e616a041ee4d7cef9849751770bc7c39adaf78a94ea145c488059'
default['python']['configure_options'] = %W{--prefix=#{python['prefix_dir']}}
default['python']['make_options'] = %W{install}

default['python']['pip_location'] = "#{node['python']['prefix_dir']}/bin/pip"
default['python']['virtualenv_location'] = "#{node['python']['prefix_dir']}/bin/virtualenv"

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

major_version = node['platform_version'].split('.').first.to_i
if node['python']['install_method'] == 'package'
  # COOK-1016 Handle RHEL/CentOS namings of python packages, by installing EPEL
  # repo & package
  case node["platform_family"]
  when 'rhel'
    include_recipe 'yum::epel'
    if major_version < 6
      # rhel 5 defaults of py24 is laffable, better use source.
      install_ez_from_source = true
      install_pip_from_source = true
    else
      pip_pkgs = ["python-setuptools", "python-pip"]
    end
  when 'debian'
    pip_pkgs = ["python-pip", "python-setuptools"]
  else
    install_ez_from_source = true
    install_pip_from_source = true
  end
  if pip_pkgs
    pip_pkgs.each do |pkg|
      package pkg do
        action :install
      end
    end
  end
end

if node['python']['install_method'] == 'source'
  pip_binary = "#{node['python']['prefix_dir']}/bin/pip"
  install_ez_from_source = true
  install_pip_from_source = true
else
  if platform_family?("rhel")
    pip_binary = "/usr/bin/pip"
  elsif platform_family?("smartos")
    pip_binary = "/opt/local/bin/pip"
  else
    pip_binary = "/usr/local/bin/pip"
  end
end

if install_ez_from_source
  cookbook_file "#{Chef::Config[:file_cache_path]}/ez_setup.py" do
    source 'ez_setup.py'
    mode "0644"
    not_if "#{node['python']['binary']} -c 'import setuptools'"
  end
  execute "install-setuptools" do
    cwd Chef::Config[:file_cache_path]
    command <<-EOF
    #{node['python']['binary']} ez_setup.py
    EOF
    not_if "#{node['python']['binary']} -c 'import setuptools'"
  end
end

if install_pip_from_source
  cookbook_file "#{Chef::Config[:file_cache_path]}/get-pip.py" do
    source 'get-pip.py'
    mode "0644"
    not_if { ::File.exists?(pip_binary) }
  end
  execute "install-pip" do
    cwd Chef::Config[:file_cache_path]
    command <<-EOF
    #{node['python']['binary']} get-pip.py
    EOF
    not_if { ::File.exists?(pip_binary) }
  end
end

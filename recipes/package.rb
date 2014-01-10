#
# Author:: Seth Chisamore <schisamo@opscode.com>
# Cookbook Name:: python
# Recipe:: package
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

major_version = node['platform_version'].split('.').first.to_i

# COOK-1016 Handle RHEL/CentOS namings of python packages, by installing EPEL
# repo & package
if platform_family?('rhel') && major_version < 6
  include_recipe 'yum::epel'
  python_pkgs = ["python26", "python26-devel"]
  node['python']['binary'] = "/usr/bin/python26"
else
  if node.platform_family? 'mac_os_x'
    case Chef::Platform.find_provider_for_node(node, :package).to_s.split['::'].last
    when 'Macports'
      python_pkgs = ['python27']
    when 'Homebrew'
      python_pkgs = ['python']
    else
      python_pkgs = ['python']
    end
  else
    python_pkgs = node['python']['packages']
  end
end

python_pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

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

default['python']['binary'] = "#{python['prefix_dir']}/bin/python"

default['python']['url'] = 'http://www.python.org/ftp/python'
default['python']['version'] = '2.7.1'
default['python']['configure_options'] = %W{--prefix=#{python['prefix_dir']}}

if platform?('windows')
  if kernel['machine'] =~ /x86_64/
    default['python']['checksum'] = '48ad736ec1bd74115df47f56c4ea770bc39dcde96a3f94270a549167e7f4dc65'
  else
    default['python']['checksum'] = '0af8bc05a5f9ed15df120150c6a6ddd0fc50d018e35b891cba22040e0404dfb6'
  end
else
  default['python']['checksum'] = '80e387bcf57eae8ce26726753584fd63e060ec11682d1145af921e85fd612292'
end
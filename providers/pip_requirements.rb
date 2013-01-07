#
# Author:: Seth Chisamore <schisamo@opscode.com>
# Author:: Cameron Johnston <cameron@rootdown.net>
# Cookbook Name:: python
# Provider:: pip_requirements.rb
#
# Copyright:: 2011, Opscode, Inc <legal@opscode.com>
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

require 'chef/mixin/shell_out'
require 'chef/mixin/language'
include Chef::Mixin::ShellOut

action :install do
  @new_resource.requirements(load_requirements_file(@new_resource.file))
  if requirements_differ?
    Chef::Log.info("Installing requirements from #{@new_resource.file}")
    status = install_requirements(@new_resource.file)
    if status
      @new_resource.updated_by_last_action(true)
    end
  end
end

action :remove do
  Chef::Log.info("Uninstalling requirements from #{@new_resource.file}")
  status = uninstall_requirements(@new_resource.file)
  if status
    @new_resource.updated_by_last_action(true)
  end
end

def load_current_resource()
  @current_resource = Chef::Resource::PythonPipRequirements.new(@new_resource.name)
  @current_resource.file(@new_resource.file)
  @current_resource.virtualenv(@new_resource.virtualenv)
  @current_resource.requirements(load_requirements_pip)
end

def load_requirements_file(file)
  requirements = {}

  Chef::Log.debug("Loading requirements file #{@new_resource.file}")

  ::File.open(file,'r') do |f|
    f.each_line do |l|
      # ignore comments
      next if l.start_with? /#/
      # ignore allowed in-line options (from pip source)
      next if l.start_with? %w{
        --requirement -r
        --always-unzip -Z
        -f -i --index-url
        --extra-index-url
        --find-links
      }

      delimeter = l.match(/\W?=/).to_s
      if delimeter
        requirements.merge!({
          l.split(delimeter)[0].strip.downcase => {
            :version => l.split(delimeter)[1].strip,
            :comparison => delimeter
          }
        })
      else
        Chef::Log.error("Could not find delimeter in line: " + l.inspect)
      end
    end
  end

  Chef::Log.debug("Requirements loaded from #{@new_resource.file}: " + requirements.inspect)

  requirements
end

def load_requirements_pip
  delimeter = "=="
  requirements = {}

  Chef::Log.debug("Loading module list from pip")

  current_modules = pip_cmd('freeze').stdout.split("\n")
  current_modules.each do |m|
    requirements.merge!({
      m.split(delimeter)[0].strip.downcase => {
        :version => m.split(delimeter)[1].strip,
        :comparison => delimeter
      }
    })
  end

  Chef::Log.debug('Loaded the following module list from pip: ' + requirements.inspect)

  requirements
end

def requirements_differ?
  different = false
  @new_resource.requirements.each do |pkg,meta|
    if @current_resource.requirements.has_key?(pkg)
      unless eval("\"#{current_resource.requirements[pkg][:version]}\" #{meta[:comparison]} \"#{meta[:version]}\"")
        Chef::Log.debug("Requirements differ for #{pkg}: current version ==#{@current_resource.requirements[pkg][:version]}, desired version #{@new_resource.requirements[pkg][:comparison]}#{@new_resource.requirements[pkg][:version]}")
        different = true
      end
    else
      Chef::Log.debug("Package #{pkg} not present")
      different = true
    end
  end
  different
end

def install_requirements(file)
  pip_cmd("install -r #{file}")
end

def uninstall_requirements(file)
  pip_cmd("uninstall -r #{file}")
end

def pip_cmd(subcommand)
  options = { :timeout => @new_resource.timeout, :user => @new_resource.user, :group => @new_resource.group }
  options[:environment] = { 'HOME' => ::File.expand_path("~#{@new_resource.user}") } if @new_resource.user
  if subcommand == 'freeze'
    shell_out!("#{which_pip(@new_resource)} #{subcommand}", options)
  else
    shell_out!("#{which_pip(@new_resource)} #{subcommand} #{@new_resource.options}", options)
  end
end

# TODO remove when provider is moved into Chef core
# this allows PythonPip to work with Chef::Resource::Package
def which_pip(nr)
  if (nr.respond_to?("virtualenv") && nr.virtualenv)
    ::File.join(nr.virtualenv,'/bin/pip')
  elsif "#{node['python']['install_method']}".eql?("source")
    ::File.join("#{node['python']['prefix_dir']}","/bin/pip")
  else
    'pip'
  end
end
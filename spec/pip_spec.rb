# -*- coding: utf-8 -*-

require 'spec_helper'

describe 'python::pip' do
  before do
    # Chef won't run without a stubbed default "true" value for ::File.exists?:
    ::File.stub(:exists?).and_return(true)
    ::File.stub(:exists?).with('/usr/bin/pip').and_return(false)
    ::File.stub(:exists?).with('/usr/local/bin/pip').and_return(false)
    ::File.stub(:exists?).with('/opt/local/bin/pip').and_return(false)
  end

  describe 'on a source install' do
    it 'uses /usr/local/bin/python to install pip on a source install' do
      chef_run = ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04')
      chef_run.node.set['python']['install_method'] = 'source'
      chef_run.converge(described_recipe)
      expect(chef_run).to run_execute('install-pip').with(
        command: "  /usr/local/bin/python get-pip.py\n")
    end
  end

  describe 'on an unknown platform package install' do
    it 'uses /usr/bin/python to install pip' do
      chef_run = ChefSpec::Runner.new.converge(described_recipe)
      expect(chef_run).to run_execute('install-pip').with(
        command: "  /usr/bin/python get-pip.py\n")
    end
  end

  describe 'on Debian-family platforms' do
    it 'uses /usr/bin/python to install pip' do
      chef_run = ChefSpec::Runner.new(
        platform: 'ubuntu', version: '12.04').converge(
        described_recipe)
      expect(chef_run).to run_execute('install-pip').with(
        command: "  /usr/bin/python get-pip.py\n")
    end
  end

  describe 'on Fedora-family platforms' do
    it 'uses /usr/bin/python to install pip' do
      chef_run = ChefSpec::Runner.new(
        platform: 'fedora', version: '18').converge(
        described_recipe)
      expect(chef_run).to run_execute('install-pip').with(
        command: "  /usr/bin/python get-pip.py\n")
    end
  end

  describe 'on FreeBSD-family platforms' do
    it 'uses /usr/bin/python to install pip' do
      chef_run = ChefSpec::Runner.new(
        platform: 'freebsd', version: '9.1').converge(
        described_recipe)
      expect(chef_run).to run_execute('install-pip').with(
        command: "  /usr/bin/python get-pip.py\n")
    end
  end

  describe 'on Red Hat-family platforms with version < 6' do
    it 'uses the python26 binary to install pip' do
      # Need to converge python::package via python::default to properly set
      # node['python']['binary']!
      chef_run = ChefSpec::Runner.new(
        platform: 'redhat', version: '5.10').converge(
        'python::default')
      expect(chef_run).to run_execute('install-pip').with(
        command: "  /usr/bin/python26 get-pip.py\n")
    end
  end

  describe 'on Red Hat-family platforms with version > 6' do
    it 'uses /usr/bin/python to install pip' do
      chef_run = ChefSpec::Runner.new(
        platform: 'redhat', version: '6.0').converge(
        described_recipe)
      expect(chef_run).to run_execute('install-pip').with(
        command: "  /usr/bin/python get-pip.py\n")
    end
  end

  describe 'on SmartOS-family platforms' do
    it 'uses /opt/local/bin/python to install pip' do
      chef_run = ChefSpec::Runner.new(
        platform: 'smartos', version: 'joyent_20130111T180733Z').converge(
        described_recipe)
      expect(chef_run).to run_execute('install-pip').with(
        command: "  /opt/local/bin/python get-pip.py\n")
    end
  end
end

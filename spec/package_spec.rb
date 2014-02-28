# -*- coding: utf-8 -*-

require 'spec_helper'

describe 'python::package' do
  describe 'on an unknown platform' do
    it 'sets the python packages to python and python-dev' do
      chef_run = ChefSpec::Runner.new.converge(described_recipe)
      expect(chef_run).to install_package('python')
      expect(chef_run).to install_package('python-dev')
    end
  end

  describe 'on Debian-family platforms' do
    it 'sets the python packages to python and python-dev' do
      chef_run = ChefSpec::Runner.new(
        platform: 'ubuntu', version: '12.04').converge(
        described_recipe)
      expect(chef_run).to install_package('python')
      expect(chef_run).to install_package('python-dev')
    end
  end

  describe 'on Fedora-family platforms' do
    it 'sets the python packages to python and python-devel' do
      chef_run = ChefSpec::Runner.new(
        platform: 'fedora', version: '18').converge(
        described_recipe)
      expect(chef_run).to install_package('python')
      expect(chef_run).to install_package('python-devel')
    end
  end

  describe 'on FreeBSD-family platforms' do
    it 'sets the python packages to python' do
      chef_run = ChefSpec::Runner.new(
        platform: 'freebsd', version: '9.1').converge(
        described_recipe)
      expect(chef_run).to install_package('python')
    end
  end

  describe 'on Red Hat-family platforms with version < 6' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'redhat', version: '5.10').converge(
        described_recipe)
    end

    it 'sets the python packages to python26 and python26-devel' do
      expect(chef_run).to install_package('python26')
      expect(chef_run).to install_package('python26-devel')
    end

    it 'includes the yum-epel recipe' do
      expect(chef_run).to include_recipe('yum-epel')
    end
  end

  describe 'on Red Hat-family platforms with version > 6' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'redhat', version: '6.0').converge(
        described_recipe)
    end

    it 'sets the python packages to python and python-devel' do
      expect(chef_run).to install_package('python')
      expect(chef_run).to install_package('python-devel')
    end

    it 'does not inlcude the yum-epel recipe' do
      expect(chef_run).not_to include_recipe('yum-epel')
    end
  end

  describe 'on SmartOS-family platforms' do
    it 'sets the python packages to python27' do
      chef_run = ChefSpec::Runner.new(
        platform: 'smartos', version: 'joyent_20130111T180733Z').converge(
        described_recipe)
      expect(chef_run).to install_package('python27')
    end
  end
end

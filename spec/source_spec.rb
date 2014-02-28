# -*- coding: utf-8 -*-

require 'spec_helper'

describe 'python::source' do

  before do
    # Chef won't run without a stubbed default "true" value for ::File.exists?:
    ::File.stub(:exists?).and_return(true)
    ::File.stub(:exists?).with('/usr/local/bin/python').and_return(false)
    ::File.stub(:exists?).with('/usr/local/bin/python2.7').and_return(false)
  end

  describe 'on a non-Red Hat plaform' do
    it 'installs the default package set' do
      chef_run = ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04')
      chef_run.node.set['python']['install_method'] = 'source'
      chef_run.converge(described_recipe)
      %w{ libssl-dev libbz2-dev zlib1g-dev libexpat1-dev libdb-dev
          libsqlite3-dev libncursesw5-dev libncurses5-dev libreadline-dev
          libsasl2-dev libgdbm-dev }.each do |pkg|
        expect(chef_run).to install_package(pkg)
      end
    end
  end

  describe 'on Red Hat-family platforms' do
    it 'installs the rhel-specific package set' do
      chef_run = ChefSpec::Runner.new(platform: 'redhat', version: '6.0')
      chef_run.node.set['python']['install_method'] = 'source'
      chef_run.converge(described_recipe)
      %w{ openssl-devel bzip2-devel zlib-devel expat-devel db4-devel
          sqlite-devel ncurses-devel readline-devel }.each do |pkg|
        expect(chef_run).to install_package(pkg)
      end
    end
  end
end

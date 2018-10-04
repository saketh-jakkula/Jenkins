#
# Cookbook:: jenkins
# Spec:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'jenkins::default' do
  context 'When all attributes are default, on Ubuntu 16.04' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'updates apt' do
	expect(chef_run).to run_execute 'apt-get update'
    end

    it 'downloads the key' do
	expect(chef_run).to create_remote_file '/tmp/jenkins-ci.org.key'
    end

    it 'execute apt-key add' do
	expect(chef_run.remote_file('/tmp/jenkins-ci.org.key')).to notify('execute[apt key add]').to(:run).immediately
    end

    it 'edits the jenkins.list' do
	expect(chef_run).to create_file '/etc/apt/sources.list.d/jenkins.list'
    end
  
    it 'updates apt' do
	expect(chef_run.file('/etc/apt/sources.list.d/jenkins.list')).to notify('execute[apt update]').to(:run).immediately
    end

    it 'installs java' do
	expect(chef_run).to install_package 'openjdk-8-jre-headless'
    end

    it 'installs jenkins' do
	expect(chef_run).to install_package 'jenkins'
    end

    it 'start jenkins' do
	expect(chef_run).to start_service 'jenkins'
    end
end

end

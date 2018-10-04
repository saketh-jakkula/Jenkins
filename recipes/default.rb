#
# Cookbook:: jenkins
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

execute 'apt update' do
  command 'apt-get update'
end

remote_file '/tmp/jenkins-ci.org.key' do
  source 'https://pkg.jenkins.io/debian/jenkins-ci.org.key'
  notifies :run, 'execute[apt key add]', :immediately
end

execute 'apt key add' do
  command 'apt-key add /tmp/jenkins-ci.org.key'
  action :nothing
end

file '/etc/apt/sources.list.d/jenkins.list' do
  content 'deb http://pkg.jenkins.io/debian-stable binary/'
  notifies :run, 'execute[apt update]', :immediately
end

execute 'apt update' do
  command 'apt-get update'
  action :nothing
end

package 'openjdk-8-jre-headless'

package 'jenkins'

service 'jenkins' do
  action :start
end

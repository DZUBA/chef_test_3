#
# Cookbook Name:: chef_task_3
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'chefspec'

describe 'chef_task_3::httpd' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'installs httpd' do
    stub_command("/usr/sbin/apache2 -t").and_return(true)
    expect(chef_run).to install_package('httpd')
  end

  it 'enables httpd' do
    stub_command("/usr/sbin/apache2 -t").and_return(true)
    expect(chef_run).to enable_service('httpd')
  end
end

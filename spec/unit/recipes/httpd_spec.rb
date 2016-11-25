#
# Cookbook Name:: chef_task_3
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'chefspec'

describe 'chef_task_3::httpd' do
  let(:chef_run) { ChefSpec::ServerRunner.converge(described_recipe) }

  it 'web_app' do
    expect(stub_command('/usr/sbin/apache2 -t').and_return(true))
  end
end

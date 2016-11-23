#
# Cookbook Name:: chef_task_3
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'
require 'chef-vault'

describe 'chef_task_3::databases' do
  before do
    allow_any_instance_of(Chef::Recipe).to receive(:data_bag).with('admins').and_return('mysql.json')
    allow_any_instance_of(Chef::Recipe).to receive(:chef_vault_item).with('admins', 'mysql').and_return(id: 'mysql', user: 'root')
  end
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'mysql_service' do
    expect(chef_run).to create_mysql_service('default')
  end

  it 'check prod_db availability' do
    stub_command("echo 'SHOW SCHEMAS;' | /usr/bin/mysql -u service_prod -h 127.0.0.1 -P 3306 | grep prod_db").and_return(true)
    expect { chef_run }.to_not raise_error
  end

  it 'check stage_db availability' do
    stub_command("echo 'SHOW SCHEMAS;' | /usr/bin/mysql -u service_stage -h 127.0.0.1 -P 3306 | grep stage_db").and_return(true)
    expect { chef_run }.to_not raise_error
  end
end

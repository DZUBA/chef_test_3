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
    stub_command("mysql -h127.0.0.1 -P3306 -p -uroot -Dstage_db -e 'describe customers;'").and_return(true)
    stub_command("mysql -h127.0.0.1 -P3306 -p -uroot -Dprod_db -e 'describe customers;'").and_return(true)
  end
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'isntall and start mysql_service' do
    expect(chef_run).to start_mysql_service('default')
  end

  it 'install mysql2_chef_gem' do
    expect(chef_run).to install_mysql2_chef_gem('install_mysql2_chef_gem')
  end

  it 'mysql databases creation' do
    expect(chef_run).to create_mysql_database('stage_db')
    expect(chef_run).to create_mysql_database('prod_db')
  end

  it 'mysql users creation' do
    expect(chef_run).to grant_mysql_database_user('service_stage')
    expect(chef_run).to grant_mysql_database_user('service_prod')
  end

  it 'dump directory creation' do
    expect(chef_run).to create_directory('/tmp/mysql_dump')
  end

  it 'crons creation' do
    expect(chef_run).to create_cron('stage_db_dump').with(hour: '1')
    expect(chef_run).to create_cron('prod_db_dump').with(hour: '1')
  end
end

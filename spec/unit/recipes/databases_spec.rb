#
# Cookbook Name:: chef_task_3
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'chef_task_3::databases' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }


  it 'mysql_service' do
    stub_data_bag_item('admins', 'mysql').and_return(id: 'mysql', user: 'root')
    expect(chef_run).to create_mysql_service('default')
  end

  it 'check prod_db availability' do
    stub_data_bag_item('admins', 'mysql').and_return(id: 'mysql', user: 'root')
    stub_command("echo 'SHOW SCHEMAS;' | /usr/bin/mysql -u root -h 127.0.0.1 -P 3306 -pchangeMe | grep prod_db").and_return(true)
    expect { chef_run }.to_not raise_error
  end

  it 'check stage_db availability' do
    stub_data_bag_item('admins', 'mysql').and_return(id: 'mysql', user: 'root')
    stub_command("echo 'SHOW SCHEMAS;' | /usr/bin/mysql -u root -h 127.0.0.1 -P 3306 -pchangeMe | grep stage_db").and_return(true)
    expect { chef_run }.to_not raise_error
  end
end

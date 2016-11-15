#
# Cookbook Name:: chef_task_3
# Recipe:: databases
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'yum'
include_recipe 'simple_iptables'

# data bags init
mysql_bag = data_bag_item('admins', 'mysql')
stage_bag = data_bag_item('databases', 'stage')
prod_bag = data_bag_item('databases', 'prod')

# MySQL creds
mysql_user = mysql_bag['user']
mysql_passwd = mysql_bag['pass']
stage_user = stage_bag['db_user']
stage_db = stage_bag['db_name']
prod_user = prod_bag['db_user']
prod_db = prod_bag['db_name']
inst_name = mysql_bag['inst']

mysql_service 'default' do
  port '3306'
  version '5.5'
  instance "#{inst_name}"
  initial_root_password "#{mysql_passwd}"
  action [:create, :start]
end

mysql2_chef_gem 'inst' do
  action :install
end

mysql_connection_info = {
    :host     => '127.0.0.1',
    :username => "#{mysql_user}",
    :socket   => "/var/run/mysql-#{inst_name}/mysqld.sock",
    :password => "#{mysql_passwd}"
}

mysql_database 'stage_db' do
  connection mysql_connection_info
  action :create
end

mysql_database 'prod_db' do
  connection mysql_connection_info
  action :create
end

mysql_database_user 'service-stage' do
  connection    mysql_connection_info
  database_name 'stage_db'
  host          '%'
  privileges    [:select,:update,:insert]
  action        :grant
end

mysql_database_user 'service_prod' do
  connection    mysql_connection_info
  database_name 'prod_db'
  host          '%'
  privileges    [:select,:update,:insert]
  action        :grant
end

simple_iptables_rule "mysql" do
  rule "--proto tcp --dport 3306"
  jump "ACCEPT"
end

#
# Cookbook Name:: chef_task_3
# Recipe:: databases
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'yum'
#include_recipe 'chef-vault'

# data bags init
mysql_bag = data_bag_item('admins', 'mysql')

# MySQL creds
mysql_passwd = mysql_bag['pass']

# mysql service install and start
mysql_ser_install = mysql_service 'default' do
  port '3306'
  version '5.5'
  instance 'default'
  initial_root_password 'changeMe'
  action [:create, :start]
end

# mysql2_chef_gem package to use database cookbook
mysql2_chef_gem 'inst' do
  action :install
end

# mysql creds
mysql_connection_info = {
  host: '127.0.0.1',
  username: 'root',
  socket: '/var/run/mysql-default/mysqld.sock',
  password: 'changeMe'
}

# import schema file
cookbook_file '/tmp/schema.sql' do
  sensitive true
  source 'schema.sql'
end

# create stage_db
mysql_database 'stage_db' do
  sensitive true
  connection mysql_connection_info
  action :create
  only_if { mysql_ser_install.updated_by_last_action? }
  notifies :run, 'execute[stage_import]', :delayed
end

# create prod_db
mysql_database 'prod_db' do
  sensitive true
  connection mysql_connection_info
  action :create
  only_if { mysql_ser_install.updated_by_last_action? }
  notifies :run, 'execute[prod_import]', :delayed
end

# create user for stage_db
mysql_database_user 'service_stage' do
  sensitive true
  connection    mysql_connection_info
  database_name 'stage_db'
  host          '%'
  privileges    [:all]
  action        :grant
  only_if { mysql_ser_install.updated_by_last_action? }
end

# create user for prod_db
mysql_database_user 'service_prod' do
  sensitive true
  connection    mysql_connection_info
  database_name 'prod_db'
  host          '%'
  privileges    [:all]
  action        :grant
  only_if { mysql_ser_install.updated_by_last_action? }
  notifies :run, 'execute[root_passwd]', :delayed
  notifies :run, 'execute[dir_for_dump]'
end

# importing stage_db schema
execute 'stage_import' do
  sensitive true
  command 'mysql -h127.0.0.1 -P3306 -pchangeMe -uroot -Dstage_db < /tmp/schema.sql'
  action :nothing
end

# importing prod_db schema
execute 'prod_import' do
  sensitive true
  command 'mysql -h127.0.0.1 -P3306 -pchangeMe -uroot -Dprod_db < /tmp/schema.sql'
  action :nothing
end

# changing root password
execute 'root_passwd' do
  sensitive true
  command "mysqladmin -uroot -pchangeMe -h127.0.0.1 -P3306 password #{mysql_passwd}"
  action :nothing
end

# create dir
execute 'dir_for_dump' do
  action :nothing
  command 'mkdir /tmp/mysql_dump'
end

# create cron for stage_db dump
cron 'stage_db_dump' do
  hour '1'
  command 'mysqldump -h127.0.0.1 -P3306 -uservice_stage stage_db > /tmp/mysql_dump/stage_db.dump'
end

# create cron for cron_db dump
cron 'prod_db_dump' do
  hour '1'
  command 'mysqldump -h127.0.0.1 -P3306 -uservice_prod prod_db > /tmp/mysql_dump/prod_db.dump'
end

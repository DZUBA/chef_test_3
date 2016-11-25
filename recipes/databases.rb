#
# Cookbook Name:: chef_task_3
# Recipe:: databases
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'yum'
include_recipe 'chef-vault'

# data bags init
mysql_bag = chef_vault_item('admins', 'mysql')

# MySQL creds
mysql_passwd = mysql_bag['pass']

# mysql service install and start
mysql_service 'default' do
  port '3306'
  version '5.5'
  instance 'default'
  initial_root_password mysql_bag['pass']
  action [:create, :start]
end

# mysql2_chef_gem package to use database cookbook
mysql2_chef_gem 'install_mysql2_chef_gem' do
  action :install
end

# mysql creds
mysql_connection_info = {
  host: '127.0.0.1',
  username: 'root',
  socket: '/var/run/mysql-default/mysqld.sock',
  password: mysql_bag['pass']
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
end

# create prod_db
mysql_database 'prod_db' do
  sensitive true
  connection mysql_connection_info
  action :create
end

# create user for stage_db
mysql_database_user 'service_stage' do
  sensitive true
  connection    mysql_connection_info
  database_name 'stage_db'
  host          '%'
  privileges    [:all]
  action        :grant
end

# create user for prod_db
mysql_database_user 'service_prod' do
  sensitive true
  connection    mysql_connection_info
  database_name 'prod_db'
  host          '%'
  privileges    [:all]
  action        :grant
end

# importing stage_db schema
execute 'stage_import' do
  sensitive true
  command "mysql -h127.0.0.1 -P3306 -p#{mysql_passwd} -uroot -Dstage_db < /tmp/schema.sql"
  not_if  "mysql -h127.0.0.1 -P3306 -p#{mysql_passwd} -uroot -Dstage_db -e 'describe customers;'"
end

# importing prod_db schema
execute 'prod_import' do
  sensitive true
  command "mysql -h127.0.0.1 -P3306 -p#{mysql_passwd} -uroot -Dprod_db < /tmp/schema.sql"
  not_if  "mysql -h127.0.0.1 -P3306 -p#{mysql_passwd} -uroot -Dprod_db -e 'describe customers;'"
end

# create dir
directory '/tmp/mysql_dump' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
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

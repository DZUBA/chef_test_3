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

# import schema file
cookbook_file '/tmp/schema.sql' do
  sensitive true
  source 'schema.sql'
end

mysql_database 'stage_db' do
  sensitive true
  connection mysql_connection_info
  action :create
  notifies :run, 'execute[stage_import]', :delayed
#  notifies :run, 'cron[stage_db_dump]', :delayed
end

mysql_database 'prod_db' do
  sensitive true
  connection mysql_connection_info
  action :create
  notifies :run, 'execute[prod_import]', :delayed
#  notifies :run, 'cron[prod_db_dump]', :delayed
end

mysql_database_user 'service-stage' do
  sensitive true
  connection    mysql_connection_info
  database_name 'stage_db'
  host          '%'
  privileges    [:select,:update,:insert]
  action        :grant
end

mysql_database_user 'service_prod' do
  sensitive true
  connection    mysql_connection_info
  database_name 'prod_db'
  host          '%'
  privileges    [:select,:update,:insert]
  action        :grant
end

mysql_database_user 'dump' do
  sensitive true
  connection    mysql_connection_info
  database_name 'stage_db'
  host          '%'
  privileges    [:select]
  action        :grant
end

mysql_database_user 'dump' do
  sensitive true
  connection    mysql_connection_info
  database_name 'prod_db'
  host          '%'
  privileges    [:select]
  action        :grant
end

# importing stage_db schema
execute 'stage_import' do
  sensitive true
  command "mysql -h127.0.0.1 -P3306 -p#{mysql_passwd} -u#{mysql_user} -Dstage_db < /tmp/schema.sql"
  action :nothing
end

# importing prod_db schema
execute 'prod_import' do
  sensitive true
  command "mysql -h127.0.0.1 -P3306 -p#{mysql_passwd} -u#{mysql_user} -Dprod_db < /tmp/schema.sql"
  action :nothing
end

execute 'dir_for_dump' do
  command "mkdir /tmp/mysql_dump"
  not_if { ::File.directory?("/tmp/mysql_dump") }
end

# create cron for stage_db dump
cron 'stage_db_dump' do
  hour '1'
  command "mysqldump -h127.0.0.1 -P3306 -udump stage_db > /tmp/mysql_dump/stage_db.dump\ "
end

# create cron for cron_db dump
cron 'prod_db_dump' do
  hour '1'
  command "mysqldump -h127.0.0.1 -P3306 -udump stage_db > /tmp/mysql_dump/prod_db.dump\ "
end

simple_iptables_rule "mysql" do
  sensitive true
  rule "--proto tcp --dport 3306"
  jump "ACCEPT"
end

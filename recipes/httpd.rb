#
# Cookbook Name:: chef_task_3
# Recipe:: httpd
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# install apache
package 'httpd' do
  action :install
end

# start apache
service 'httpd' do
  action [:start, :enable]
end

# config for dump site
web_app 'dump_site' do
  template 'dump.erb'
end

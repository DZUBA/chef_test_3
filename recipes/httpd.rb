#
# Cookbook Name:: chef_task_3
# Recipe:: httpd
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# config for dump site
web_app 'dump_site' do
  server_name 'dump_site'
  template 'dump.erb'
end

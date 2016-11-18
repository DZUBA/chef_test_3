#
# Cookbook Name:: chef_task_3
# Recipe:: httpd
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'simple_iptables'

# install apache
package 'httpd' do
  action :install
end

# start apache
service 'httpd' do
  action :start
end

# config for dump site
web_app 'dump_site' do
  template 'dump.erb'
end

# iptables rule for apache
simple_iptables_rule 'web' do
  rule '--proto tcp --dport 80'
  jump 'ACCEPT'
end

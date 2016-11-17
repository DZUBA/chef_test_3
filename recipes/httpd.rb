#
# Cookbook Name:: chef_task_3
# Recipe:: httpd
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'simple_iptables'

httpd_service 'default' do
  action [:create, :start]
end

simple_iptables_rule "web" do
  rule "--proto tcp --dport 80"
  jump "ACCEPT"
end

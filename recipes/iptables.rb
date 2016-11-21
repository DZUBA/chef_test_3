#
# Cookbook Name:: chef_task_3
# Recipe:: ./iptables
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'simple_iptables'

# iptables rule for mysql
simple_iptables_rule 'mysql' do
  sensitive true
  rule '--proto tcp --dport 3306'
  jump 'ACCEPT'
end

# iptables rule for apache
simple_iptables_rule 'web' do
  rule '--proto tcp --dport 80'
  jump 'ACCEPT'
end

mysql_service 'default' do
  port '3306'
  name 'localhost'
  initial_root_password 'p4ssw0rd'
  action [:create, :start]
end

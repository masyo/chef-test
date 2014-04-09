#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
yum_package "nginx" do
  action :install
end

service "nginx" do
  action [ :enable,:start ]
end

prod_backends = []
search(:node, "role:backend AND chef_environment:prod OR chef_environment:preprod") {|n| prod_backends << n[:ipaddress]}

template "/etc/nginx/nginx.conf" do
  source "nginx.conf.erb"
  mode 0644
  variables(
    :backends => prod_backends
  )
  notifies :reload, resources(:service => "nginx"), :immediately
end

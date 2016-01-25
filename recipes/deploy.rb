# start gunicorn service
service 'myapp' do
  provider Chef::Provider::Service::Upstart
  supports :status => true
  action [:restart]
end

service 'nginx' do
  action :restart
end

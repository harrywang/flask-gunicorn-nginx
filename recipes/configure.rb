include_recipe 'apt::default'

package 'python-pip'
package 'python-dev'
package 'curl'
package 'nginx'

# create app directories
directory node['flask-gunicorn-nginx']['project_dir'] do
  recursive true
end

# install gunicorn and flask
execute 'install packages' do
    command 'pip install gunicorn flask'
end

# install an application file - note: file name cannot contain hyphen
template "#{node['flask-gunicorn-nginx']['project_dir']}/myapp.py" do
  source "myapp.erb"
end

template "#{node['flask-gunicorn-nginx']['project_dir']}/wsgi.py" do
  source "wsgi.erb"
end

template "/etc/init/myapp.conf" do
   source 'myapp-gunicorn.conf.erb'
end

template "/etc/nginx/sites-available/myapp" do
   source 'myapp-nginx.conf.erb'
end

link '/etc/nginx/sites-enabled/myapp' do
  to '/etc/nginx/sites-available/myapp'
end

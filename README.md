This is a chef cookbook for the following tutorial:
https://www.digitalocean.com/community/tutorials/how-to-serve-flask-applications-with-gunicorn-and-nginx-on-ubuntu-14-04

My notes:

1. `kitchen init`, edit .kitchen.yml to remove `- name: centos-7.1`
2. add metadata.rb, `name 'flask-gunicorn-nginx'` specify the cookbook's name, which is used in .kitchen.yml     `run_list: - recipe[flask-gunicorn-nginx::configure]`
3. add external cookbook in metatdata.rb `depends 'apt', '~> 2.9.2'` and add Berksfile
4. create configure.rb and include one line `include_recipe 'apt::default'`
5. run `kitchen converge` (no need to run `berks install`, somehow all external cookbook, i.e. apt cookbook, is automatically downloaded into ~/.berksfile/cookbooks)
6. install python-pip python-dev nginx by adding packages in configure.rb
7. create app directories, add attributes in attributes/default.rb
`default['flask-gunicorn-nginx']['project_dir'] = '/srv/www/myapp/'`
and add code in configure.rb to create those folders (make sure the attributes match the node[] code, otherwise there will be errors when trying to converge)
8. create a few files, myapp.py (there cannot be hyphen in file name otherwise gunicorn error) and wsgi.py using templates and test gunicorn
9. Upstart script: import: when working with Test Kitchen locally - there is no user named "ubuntu" instead, please use user vagrant: `setuid vagrant`
10. Make sure the socket file is in /tmp folder for permission reason in both myapp-gunicorn.conf.erb and myapp-nginx.conf.erb
11. add deploy.rb to start the services
12. add `network: - ["forwarded_port", {guest: 80, host: 8888}]` for port forwarding.
13. `kitchen converge` >> open a browser locally, and enter http://127.0.0.1:8888, you should be able to see Hello There message.
14. if ever need to use AWS OpsWorks, `berks package` and upload the generated tarball to S3

TODO:

- try to remove the Berksfile and run apt directly

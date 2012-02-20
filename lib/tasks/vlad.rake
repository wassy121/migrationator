begin
  require 'vlad'
  Vlad.load :scm => :git
rescue
 # do nothing
end

namespace :vlad do
  remote_task :mkdaemon do
    run "sudo mv /tmp/#{myapp} /service/"
  end
  remote_task :bundle do
    run "cd /usr/local/#{myapp}/current/ && bundle install &"
  end
  remote_task :restart do 
    run "sudo service httpd restart" 
  end 
  remote_task :logtail do
    run "tail /usr/local/#{myapp}/log/production.log -n 100"
  end
  task :deploy => [:update, :restart]
end
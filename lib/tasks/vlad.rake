begin
  require 'vlad'
  Vlad.load :scm => :git
rescue
 # do nothing
end

require 'bundler/vlad'

namespace :vlad do
  remote_task :restart do 
    run "sudo service httpd restart" 
  end 
  remote_task :logtail do
    run "tail /usr/local/#{application}/current/log/production.log -n 100"
  end
  task :deploy => [:update, :restart]
end
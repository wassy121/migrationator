begin
  require 'vlad'
  Vlad.load :scm => :git
rescue
 # do nothing
end

require 'bundler/vlad'

namespace :vlad do
  remote_task :update do
    Rake::Task['vlad:post_update'].invoke
  end
  remote_task :restart do 
    run "sudo service httpd restart" 
  end 
  remote_task :logtail do
    run "tail /usr/local/#{application}/current/log/production.log -n 100"
  end
  remote_task :post_update do
    run "cp /usr/local/#{application}/private/database.yml /usr/local/#{application}/current/config/database.yml"
  end
  task :deploy => [:update, :start_app]
end
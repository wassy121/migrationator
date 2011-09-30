# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
user = User.create(:email => 'user@test.com',:password => 'secret')
Admin.create(:email => 'admin@test.com',:password => 'secret')
Server.create(:name => 'test', :ip => '192.168.1.1', :user => user )

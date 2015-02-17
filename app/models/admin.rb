class Admin < ActiveRecord::Base
  devise :database_authenticatable, :recoverable,
         :rememberable, :registerable, :trackable
end

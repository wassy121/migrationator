class Server < ActiveRecord::Base
  has_many :packages, :dependent => :destroy
  belongs_to :user
end

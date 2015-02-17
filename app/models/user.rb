class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable,
         :rememberable, :registerable, :trackable

  has_many :servers, :dependent => :destroy
end

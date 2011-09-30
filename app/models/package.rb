class Package < ActiveRecord::Base
  
  known_pkgtypes = ["rpm", "deb", "gem"]
  validates_each :pkgtype do |record, attr, value|
    record.errors.add attr, 'isn\'t in' + known_pkgtypes.to_s unless known_pkgtypes.include?(value.downcase)
  end    
  belongs_to :server
  
  validates :name, :pkgversion, :architecture, :presence => true  
  
  def long_name
    [:name, :pkgversion, :architecture].join()
  end
end

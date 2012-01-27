class Package < ActiveRecord::Base
  
  SUPPORTED_PACKAGETYPES = ["rpm", "deb", "gem"]
  validates_each :pkgtype do |record, attr, value|
    record.errors.add attr, 'isn\'t in' + SUPPORTED_PACKAGETYPES.to_s unless SUPPORTED_PACKAGETYPES.include?(value.downcase)
  end    
  belongs_to :server
  
  validates :name, :pkgversion, :architecture, :presence => true  
  
  def long_name
    [:name, :pkgversion, :architecture].join()
  end
end

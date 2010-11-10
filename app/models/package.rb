class Package < ActiveRecord::Base
  
  type_array = ["rpm", "deb", "gem"]
  validates_each :type do |record, attr, value|
    record.errors.add attr, 'isn\'t in [rpm,deb,gem]' unless type_array.include?(value.downcase)
  end    
end

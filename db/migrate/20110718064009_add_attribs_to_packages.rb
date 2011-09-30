class AddAttribsToPackages < ActiveRecord::Migration
  def self.up
    add_column :packages, :pkgversion, :string
    add_column :packages, :architecture, :string
  end

  def self.down
    remove_column :packages, :pkgversion
    remove_column :packages, :architecture  
  end
end

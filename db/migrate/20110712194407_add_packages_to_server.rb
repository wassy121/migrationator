class AddPackagesToServer < ActiveRecord::Migration
  def self.up
    change_table :packages do |t|
      t.references :server
    end
  end

  def self.down
    remove_column :packages, :server_type
    remove_column :packages, :server_id
  end
end

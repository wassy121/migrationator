class CreatePackages < ActiveRecord::Migration
  def self.up
    create_table :packages do |t|
      t.string :type
      t.string :name
      t.string :version

      t.timestamps
    end
  end

  def self.down
    drop_table :packages
  end
end

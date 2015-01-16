class CreateAdmins < ActiveRecord::Migration
  def self.up
    create_table :admins do |t|
      ## Database authenticatable
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""

      t.timestamps
    end
  end

  def self.down
    drop_table :admins
  end
end

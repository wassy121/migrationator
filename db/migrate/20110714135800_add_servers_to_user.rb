class AddServersToUser < ActiveRecord::Migration
  def self.up
    change_table :servers do |t|
      t.references :user
    end
  end

  def self.down
    remove_column :servers, :user_type
    remove_column :servers, :user_id
  end
end

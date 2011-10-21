class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    User.destroy_all
    add_column :users, :encrypted_password, :string, :null => false, :limit => 128
  end

  def self.down
    remove_column :users, :encrypted_password
  end
end

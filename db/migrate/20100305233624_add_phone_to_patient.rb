class AddPhoneToPatient < ActiveRecord::Migration
  def self.up
    add_column :patients, :phone, :string
  end

  def self.down
    remove_column :patients, :phone
  end
end

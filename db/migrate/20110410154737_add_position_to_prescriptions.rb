class AddPositionToPrescriptions < ActiveRecord::Migration
  def self.up
    add_column :prescriptions, :position, :integer
  end

  def self.down
    remove_column :prescriptions, :position
  end
end

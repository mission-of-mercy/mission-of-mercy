class CreateSupportRequests < ActiveRecord::Migration
  def self.up
    create_table :support_requests do |t|
      t.integer :user_id
      t.integer :area_id
      t.integer :treatment_area_id
      t.string  :ip_address
      t.boolean :resolved
      t.datetime :resolved_at

      t.timestamps
    end
  end

  def self.down
    drop_table :support_requests
  end
end

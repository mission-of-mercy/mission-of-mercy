class CreatePatients < ActiveRecord::Migration
  def self.up
    create_table :patients do |t|
      t.string   "first_name"
      t.string   "last_name"
      t.date     "date_of_birth"
      t.string   "sex",                         :limit => 2
      t.string   "street"
      t.string   "city"
      t.string   "state",                       :limit => 2
      t.string   "zip",                         :limit => 10
      t.string   "race"
      t.float    "travel_time"
      t.boolean  "attended_previous_mom_event"
      t.string   "previous_mom_event_location"
      t.string   "chief_complaint"
      t.string   "last_dental_visit"
      t.boolean  "pain"
      t.integer  "pain_length_in_days"

      t.timestamps
    end
  end

  def self.down
    drop_table :patients
  end
end

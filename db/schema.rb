# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111021224603) do

  create_table "patient_flows", :force => true do |t|
    t.integer  "treatment_area_id"
    t.integer  "patient_id"
    t.integer  "area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patient_pre_meds", :force => true do |t|
    t.integer  "patient_id"
    t.integer  "pre_med_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "prescribed"
  end

  create_table "patient_prescriptions", :force => true do |t|
    t.integer  "patient_id"
    t.integer  "prescription_id"
    t.boolean  "prescribed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "patient_prescriptions", ["patient_id"], :name => "index_patient_prescriptions_on_patient_id"
  add_index "patient_prescriptions", ["prescription_id"], :name => "index_patient_prescriptions_on_prescription_id"

  create_table "patient_previous_mom_clinics", :force => true do |t|
    t.integer  "patient_id"
    t.string   "location"
    t.integer  "clinic_year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "attended"
  end

  create_table "patient_procedures", :force => true do |t|
    t.integer  "patient_id"
    t.integer  "procedure_id"
    t.string   "tooth_number"
    t.string   "surface_code"
    t.integer  "provider_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "patient_procedures", ["patient_id"], :name => "index_patient_procedures_on_patient_id"
  add_index "patient_procedures", ["procedure_id"], :name => "index_patient_procedures_on_procedure_id"

  create_table "patient_zipcodes", :force => true do |t|
    t.string   "zip"
    t.string   "city"
    t.string   "state"
    t.string   "latitude"
    t.string   "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "county"
  end

  add_index "patient_zipcodes", ["zip"], :name => "index_patient_zipcodes_on_zip"

  create_table "patients", :force => true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "survey_id"
    t.integer  "assigned_treatment_area_id"
    t.string   "phone"
    t.boolean  "radiology",                                 :default => false
  end

  create_table "pre_meds", :force => true do |t|
    t.string   "description"
    t.integer  "count"
    t.integer  "prescription_id"
    t.float    "cost"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prescriptions", :force => true do |t|
    t.string   "name"
    t.string   "strength"
    t.integer  "quantity"
    t.string   "dosage"
    t.float    "cost"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "procedure_treatment_area_mappings", :force => true do |t|
    t.integer  "procedure_id"
    t.integer  "treatment_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "assigned"
  end

  create_table "procedures", :force => true do |t|
    t.integer  "code"
    t.string   "description"
    t.boolean  "requires_tooth_number"
    t.boolean  "requires_surface_code"
    t.string   "procedure_type"
    t.boolean  "auto_add"
    t.float    "cost"
    t.integer  "number_of_surfaces"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "support_requests", :force => true do |t|
    t.integer  "user_id"
    t.integer  "area_id"
    t.integer  "treatment_area_id"
    t.string   "ip_address"
    t.boolean  "resolved"
    t.datetime "resolved_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surveys", :force => true do |t|
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.integer  "age"
    t.string   "sex"
    t.string   "race"
    t.integer  "rating_of_services"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "pain"
    t.integer  "pain_length_in_days"
    t.string   "heard_about_clinic"
    t.boolean  "told_needed_more_dental_treatment"
    t.boolean  "has_place_to_be_seen_for_dental_care"
    t.boolean  "no_insurance"
    t.boolean  "insurance_from_job"
    t.boolean  "medicaid_or_chp_plus"
    t.boolean  "self_purchase_insurance"
    t.string   "other_insurance"
    t.boolean  "tobacco_use"
  end

  create_table "treatment_areas", :force => true do |t|
    t.string   "name"
    t.integer  "capacity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "amalgam_composite_procedures"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.integer  "x_ray_station_id"
    t.integer  "user_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",        :limit => 128,                 :null => false
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end

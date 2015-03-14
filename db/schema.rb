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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160318131248) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "heard_about_clinics", force: true do |t|
    t.string   "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patient_assignments", force: true do |t|
    t.integer  "patient_id"
    t.integer  "treatment_area_id"
    t.datetime "checked_out_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patient_flows", force: true do |t|
    t.integer  "treatment_area_id"
    t.integer  "patient_id"
    t.integer  "area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patient_pre_meds", force: true do |t|
    t.integer  "patient_id"
    t.integer  "pre_med_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "prescribed"
  end

  create_table "patient_prescriptions", force: true do |t|
    t.integer  "patient_id"
    t.integer  "prescription_id"
    t.boolean  "prescribed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "patient_prescriptions", ["patient_id"], name: "index_patient_prescriptions_on_patient_id", using: :btree
  add_index "patient_prescriptions", ["prescription_id"], name: "index_patient_prescriptions_on_prescription_id", using: :btree

  create_table "patient_previous_mom_clinics", force: true do |t|
    t.integer  "patient_id"
    t.string   "location"
    t.integer  "clinic_year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "attended"
  end

  create_table "patient_procedures", force: true do |t|
    t.integer  "patient_id"
    t.integer  "procedure_id"
    t.string   "tooth_number"
    t.string   "surface_code"
    t.integer  "provider_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "patient_procedures", ["patient_id"], name: "index_patient_procedures_on_patient_id", using: :btree
  add_index "patient_procedures", ["procedure_id"], name: "index_patient_procedures_on_procedure_id", using: :btree

  create_table "patient_zipcodes", force: true do |t|
    t.string   "zip"
    t.string   "city"
    t.string   "state"
    t.string   "latitude"
    t.string   "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "county"
  end

  add_index "patient_zipcodes", ["zip"], name: "index_patient_zipcodes_on_zip", using: :btree

  create_table "patients", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.date     "date_of_birth"
    t.string   "sex",                         limit: 2
    t.string   "street"
    t.string   "city"
    t.string   "state",                       limit: 2
    t.string   "zip",                         limit: 10
    t.string   "race"
    t.boolean  "attended_previous_mom_event"
    t.string   "previous_mom_event_location"
    t.string   "chief_complaint"
    t.string   "last_dental_visit"
    t.boolean  "pain"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "survey_id"
    t.string   "phone"
    t.integer  "previous_chart_number"
    t.boolean  "chart_printed",                          default: false, null: false
    t.text     "language"
    t.boolean  "consent_to_research_study",              default: false
    t.text     "travel_time"
    t.text     "time_in_pain"
    t.string   "county"
    t.string   "overall_health"
  end

  create_table "pre_meds", force: true do |t|
    t.string   "description"
    t.float    "cost"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "prescriptions", force: true do |t|
    t.string   "name"
    t.string   "strength"
    t.integer  "quantity"
    t.string   "dosage"
    t.float    "cost"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "previous_clinics", force: true do |t|
    t.string   "location"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "procedure_treatment_area_mappings", force: true do |t|
    t.integer  "procedure_id"
    t.integer  "treatment_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "assigned"
  end

  create_table "procedures", force: true do |t|
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

  create_table "races", force: true do |t|
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "support_requests", force: true do |t|
    t.integer  "user_id"
    t.integer  "area_id"
    t.integer  "treatment_area_id"
    t.string   "ip_address"
    t.boolean  "resolved"
    t.datetime "resolved_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surveys", force: true do |t|
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.integer  "age"
    t.string   "sex"
    t.text     "race"
    t.integer  "rating_of_services"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "pain"
    t.text     "heard_about_clinic"
    t.boolean  "tobacco_use"
    t.text     "language"
    t.boolean  "consent_to_research_study",                          default: false
    t.text     "travel_time"
    t.text     "time_in_pain"
    t.text     "overall_health"
    t.text     "overall_dental_health"
    t.boolean  "own_a_toothbrush"
    t.text     "dental_care_home"
    t.boolean  "emergency_room_for_dental"
    t.text     "frequency_of_emergency_dental_visits_past_6_months"
    t.boolean  "told_need_more_dental_care_after_emergency_visit"
    t.boolean  "six_mo_visited_dental_office"
    t.boolean  "six_mo_visited_apple_clinic"
    t.boolean  "six_mo_visited_clay_county_cares"
    t.boolean  "six_mo_visited_sulzbacher_clinic"
    t.boolean  "six_mo_visited_baptist_emergency"
    t.boolean  "six_mo_visited_memorial_hospital_emergency"
    t.boolean  "six_mo_visited_orange_park_emergency"
    t.boolean  "six_mo_visited_st_vincent_emergency"
    t.boolean  "six_mo_visited_uf_emergency"
    t.text     "six_mo_visited_other"
    t.boolean  "dental_insurance_coverage"
    t.text     "highest_level_of_school_completed"
    t.boolean  "health_insurance_none"
    t.boolean  "health_insurance_from_employer"
    t.boolean  "health_insurance_purchased_from_insurance_co"
    t.boolean  "health_insurance_purchased_from_gov"
    t.boolean  "health_insurance_medicare"
    t.boolean  "health_insurance_medicaid"
    t.boolean  "health_insurance_military"
    t.boolean  "health_insurance_other"
    t.text     "military_service"
    t.boolean  "hispanic_latino_spanish"
    t.text     "current_work_situation"
    t.text     "household_size"
    t.boolean  "food_stamps"
    t.boolean  "wic_program_benefits"
    t.text     "household_anual_income"
    t.text     "reason_for_visit"
    t.boolean  "attended_previous_mom"
    t.string   "last_dental_visit"
    t.string   "response_type"
    t.boolean  "told_needed_more_dental_treatment"
  end

  create_table "treatment_areas", force: true do |t|
    t.string   "name"
    t.integer  "capacity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "amalgam_composite_procedures"
    t.integer  "base_processing_time_in_seconds"
  end

  create_table "treatments", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "provided",   default: true
  end

  create_table "users", force: true do |t|
    t.string   "login",                     limit: 40
    t.string   "name",                      limit: 100, default: ""
    t.string   "email",                     limit: 100
    t.string   "crypted_password",          limit: 40
    t.string   "salt",                      limit: 40
    t.string   "remember_token",            limit: 40
    t.datetime "remember_token_expires_at"
    t.integer  "x_ray_station_id"
    t.integer  "user_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",        limit: 128,              null: false
  end

  add_index "users", ["login"], name: "index_users_on_login", unique: true, using: :btree

end

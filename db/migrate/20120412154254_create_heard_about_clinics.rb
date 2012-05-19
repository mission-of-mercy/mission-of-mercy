class CreateHeardAboutClinics < ActiveRecord::Migration
  def change
    create_table :heard_about_clinics do |t|
      t.string :reason
      t.timestamps
    end
  end
end

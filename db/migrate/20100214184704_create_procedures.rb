class CreateProcedures < ActiveRecord::Migration
  def self.up
    create_table :procedures do |t|
      t.integer  "code"
      t.string   "description"
      t.boolean  "requires_tooth_number"
      t.boolean  "requires_surface_code"
      t.string   "procedure_type"
      t.boolean  "auto_add"
      t.float    "cost"
      t.integer  "number_of_surfaces"
      t.integer  "treatment_area_id"
      
      t.timestamps
    end
  end

  def self.down
    drop_table :procedures
  end
end

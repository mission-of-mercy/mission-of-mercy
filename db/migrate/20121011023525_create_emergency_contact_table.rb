class CreateEmergencyContactTable < ActiveRecord::Migration
  def up
    create_table :emergency_contacts do |t|
      t.column     :full_name, :string
      t.column     :relationship, :string
      t.column     :phone, :string
      t.references :patient
    end
  end

  def down
    drop_table :emergency_contacts
  end
end

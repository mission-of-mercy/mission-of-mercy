class AddProvidedToTreatments < ActiveRecord::Migration
  def change
    add_column :treatments, :provided, :boolean, :default => true
  end
end

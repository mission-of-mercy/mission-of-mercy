class AddInterpreterFieldsToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :interpreter_needed, :boolean, null: false,
      default: false
    add_column :patients, :language, :text
  end
end

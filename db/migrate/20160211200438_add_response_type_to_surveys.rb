class AddResponseTypeToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :response_type, :string
  end
end

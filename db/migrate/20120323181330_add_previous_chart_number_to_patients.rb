class AddPreviousChartNumberToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :previous_chart_number, :integer
  end
end

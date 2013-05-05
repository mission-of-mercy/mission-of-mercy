class AddChartPrintedToPatient < ActiveRecord::Migration
  def change
    add_column :patients, :chart_printed, :boolean, default: false, null: false
  end
end

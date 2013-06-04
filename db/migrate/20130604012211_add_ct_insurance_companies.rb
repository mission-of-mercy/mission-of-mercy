class AddCtInsuranceCompanies < ActiveRecord::Migration
  def change
    companies = %w[husky_insurance_a husky_insurance_b husky_insurance_c
      husky_insurance_d husky_insurance_unknown charter_oak ]

    companies.each do |column|
      add_column :surveys, column, :boolean, default: false, null: false
    end
  end
end

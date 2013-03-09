require Rails.root.join('app/reports/ada')

desc 'Clinic Summary Report for the ADA'
task :ada_report => [:environment] do
  report = Reports::Ada.new

  report.render_to_path(Rails.root.join("ada_report.xlsx"))
end

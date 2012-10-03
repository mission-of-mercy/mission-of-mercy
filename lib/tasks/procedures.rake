require 'csv'

namespace :procedures do

  desc 'import procedures from ./procedures.csv if present, otherwise use ./data/procedures.csv'
  setup_task :import => :environment do
    Procedure.destroy_all

    custom_file   = File.join(Rails.root, "procedures.csv")
    import_file   = custom_file if File.exists?(custom_file)
    import_file ||= File.join(Rails.root, "data", "procedures.csv")

    CSV.foreach(import_file, :headers => true) do |row|
      procedure = Procedure.create(
        :code                  => row["Procedure Code"],
        :description           => row["Description"],
        :requires_tooth_number => row["Requires Tooth Number"],
        :requires_surface_code => row["Requires Surface Code"],
        :procedure_type        => row["Procedure Type"],
        :auto_add              => row["Auto Add"],
        :cost                  => row["Cost"],
        :number_of_surfaces    => row["Number of Surfaces"]
      )

      treatment_areas = (row["Treatment Areas"] || "").split(",").reject {|t| t.blank? }

      treatment_areas.each do |name|
        treatment_area = TreatmentArea.find_by_name(name.strip)

        treatment_area.procedures << procedure if treatment_area
      end
    end

    done "#{Procedure.count} procedures sucessfully imported"
  end
end

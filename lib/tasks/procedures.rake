namespace :procedures do 

  desc 'import procedures from procedures.csv'
  task :import => :environment do
    Procedure.destroy_all
    
    FasterCSV.foreach("#{RAILS_ROOT}/procedures.csv", :headers => true) do |row|
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
    
    puts "#{Procedure.count} procedures sucessfully imported"
  end
end

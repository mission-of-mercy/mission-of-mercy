require "active_support"

namespace :zip do 

  # Zipcode CSC can be downloaded from: http://www.boutell.com/zipcodes/
  desc 'import zips from zipcode.csv'
  task :import => :environment do
    FasterCSV.foreach("#{RAILS_ROOT}/zipcode.csv", :headers => true) do |row|
      Patient::Zipcode.create(
        :zip       => row["zip"],
        :city      => row["city"].try(:titlecase),
        :state     => row["state"].try(:upcase),
        :latitude  => row["latitude"],
        :longitude => row["longitude"],
        :county    => row["county"].try(:titlecase)
      )
    end
    
    puts "Zipcodes sucessfully imported"
  end
  
  desc 'add county information to zips'
  task :add_county => :environment do
    FasterCSV.foreach("#{RAILS_ROOT}/zipcode.csv", :headers => true) do |row|
      zip_code = Patient::Zipcode.find_by_zip(row["zip"])
      
      if zip_code
        zip_code.update_attributes(:county => row["county"].try(:titlecase))
      else
        puts "#{row["zip"]} not found!"
      end
    end
    
    puts "County information sucessfully added to zips"
  end
end

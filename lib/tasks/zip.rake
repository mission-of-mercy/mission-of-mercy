namespace :zip do 

  # Zipcode CSC can be downloaded from: http://www.boutell.com/zipcodes/
  desc 'import users from zipcode.csv'
  task :import => :environment do
    FasterCSV.foreach("#{RAILS_ROOT}/zipcode.csv", :headers => true) do |row|
      Patient::Zipcode.create(
        :zip       => row["zip"],
        :city      => row["city"],
        :state     => row["state"],
        :latitude  => row["latitude"],
        :longitude => row["longitude"]
      )
    end
    
    puts "Zipcodes sucessfully imported"
  end
end

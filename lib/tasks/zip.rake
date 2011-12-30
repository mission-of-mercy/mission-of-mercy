require "active_support"
require "csv"

namespace :zip do

  desc 'import zips from zipcode.csv'
  task :import => :environment do
    zip_file = File.join(Rails.root, "zipcode.csv")

    unless File.exists?(zip_file)
      puts "#{zip_file} does not exist!".color(:red)
      puts "Zipcode CSV can be downloaded from: http://www.boutell.com/zipcodes"
      next
    end

    zip_count = File.foreach(zip_file).inject(0) {|c, line| c + 1 }

    bar = ProgressBar.new(zip_count, :bar, :percentage)

    CSV.foreach(zip_file, :headers => true) do |row|
      Patient::Zipcode.create(
        :zip       => row["zip"],
        :city      => row["city"].try(:titlecase),
        :state     => row["state"].try(:upcase),
        :latitude  => row["latitude"],
        :longitude => row["longitude"],
        :county    => row["county"].try(:titlecase)
      )

      bar.increment!
    end

    bar.increment!(bar.remaining) # The total is approximate

    puts "#{Patient::Zipcode.count} zipcodes sucessfully imported"
  end
end

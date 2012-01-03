require "active_support"
require "csv"
require "open-uri"
require "zip/zip"
require "progress_bar"

namespace :zip do

  desc 'import zips from zipcode.csv'
  task :import => :environment do
    zip_file = File.join(Rails.root, "zipcode.csv")

    unless File.exists?(zip_file)
      begin
        Rake::Task["zip:download"].invoke
      rescue
        puts "Error downloading zipcodes.".color(:red)
        next
      end
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

  task :download do
    puts "Downloading zipcodes ..."

    zip_file_path = File.join(Rails.root, "zipcode.zip")
    zip_file      = open(zip_file_path, "wb")
    zip_file.write(open('http://www.boutell.com/zipcodes/zipcode.zip').read)
    zip_file.close

    puts "Unzipping ..."

    Zip::ZipFile.open(zip_file_path) do |files|
      file = files.find {|f| f.name[/csv/] }
      files.extract(file, File.join(Rails.root, file.name))
    end

    FileUtils.rm(zip_file_path)

    puts "Zipcode CSV downloaded"
  end
end

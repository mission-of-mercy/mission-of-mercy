require "active_support"
require "csv"
require "open-uri"
require "zip/zip"

namespace :zip do

  desc 'import zips from zipcode.csv'
  setup_task :import => :environment do
    if Patient::Zipcode.any?
      done "Skip: #{Patient::Zipcode.count} zip codes already imported"
      next
    end

    zip_file = File.join(Rails.root, "zipcode.csv")

    unless File.exists?(zip_file)
      begin
        Rake::Task["zip:download"].invoke
      rescue
        puts "Error downloading zipcodes.".color(:red)
        next
      end
    end

    puts "Importing zipcodes ..."

    conn = ActiveRecord::Base.connection
    all_values = []

    CSV.foreach(zip_file, :headers => true) do |row|
      # Trivial validation - discard lines which don't start with a number
      next unless row['zip'].to_i > 0

      values = [
        row["zip"],
        row["city"].try(:titlecase),
        row["state"].try(:upcase),
        row["latitude"],
        row["longitude"],
        row["county"].try(:titlecase),
        Time.now,
        Time.now
      ].map {|field| conn.quote(field) }.join(', ')

      all_values << "(#{values})"
    end

    conn.execute %{
      INSERT INTO patient_zipcodes (zip, city, state, latitude, longitude,
                                    county, created_at, updated_at)
      VALUES #{all_values.join(',')}
    }

    done "#{Patient::Zipcode.count} zipcodes sucessfully imported"
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

    done "Zipcode CSV downloaded"
  end
end


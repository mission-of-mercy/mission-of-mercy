namespace :travis do
  desc 'Create database.yml for testing'
  task :setup do

    Rake::Task["setup:secret_token"].invoke

    # Setup config/mom.yml

    mom_file   = File.join(Rails.root, 'config', 'mom.yml')
    template   = ERB.new(File.read(mom_file + '.erb'))
    dexis_path = backup_path = Rails.root.join("tmp").to_s
    state      = "CT"

    File.open(mom_file, 'w') {|f| f.write(template.result(binding)) }

    # Setup config/database.yml
    #
    File.open(Rails.root.join("config", "database.yml"), 'w') do |f|
      f << <<-CONFIG
test:
  adapter: postgresql
  database: mom_test
  username: postgres
  min_messages: error
  encoding: utf8
CONFIG
    end

    # Create the database
    #
    `psql -c 'create database mom_test;' -U postgres`

    # Load the schema
    #
    Rake::Task["db:test:load"].invoke
  end
end
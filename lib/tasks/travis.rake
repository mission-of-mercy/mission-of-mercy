ENV["RAILS_ENV"] = "test"

namespace :travis do
  desc 'Create database.yml for testing'
  task :setup do
    File.open(Rails.root.join("config", "database.yml"), 'w') do |f|
      f << <<-CONFIG
test:
  adapter: postgresql
  database: mom_test
  username: postgres
CONFIG
    end

    `psql -c 'create database mom_test;' -U postgres`

    Rake::Task["db:test:prepare"]
    Rake::Task["db:migrate"]
  end
end
namespace :travis do
  desc 'Create database.yml for testing'
  task :setup do
    File.open(Rails.root.join("config", "database.yml"), 'w') do |f|
      f << <<-CONFIG
postgres:
  adapter: postgresql
  database: myapp_test
  username: postgres
CONFIG
    end

    `psql -c 'create database myapp_test;' -U postgres`
  end
end
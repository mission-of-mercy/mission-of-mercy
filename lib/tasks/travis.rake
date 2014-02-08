namespace :travis do
  desc 'Create database for testing'
  task :setup do
    # Create the database
    #
    `psql -c 'create database mom_test;' -U postgres`

    # Load the schema
    #
    Rake::Task["db:test:load"].invoke
  end
end

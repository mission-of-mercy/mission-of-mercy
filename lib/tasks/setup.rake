require 'fileutils'
require 'shellwords'

desc 'runs the tasks necessary to setup MoM'
task :setup do

  # Setup config files
  database_file = File.join(Rails.root, 'config', 'database.yml')
  mom_file      = File.join(Rails.root, 'config', 'mom.yml')

  unless File.exists?(database_file)
    FileUtils.cp(database_file + '.example', database_file)
    puts "Database config file created"
    edit_file(database_file)
  end

  unless File.exists?(mom_file)
    FileUtils.cp(mom_file + '.example', mom_file)
    puts "MoM config file created"
    edit_file(mom_file)
  end

  puts "Config files created"

  # Setup the database
  Rake::Task["db:create"].invoke
  Rake::Task["db:migrate"].invoke
  Rake::Task["db:test:prepare"].invoke

  puts "Database prepared"

  # Setup seed data
  Rake::Task["db:seed"].invoke
  Rake::Task["procedures:import"].invoke

  puts "Seed data loaded"

  # Run the tests
  Rake::Task["test"].invoke

  puts "--- Setup Complete ---"
end

# Inspired by open_gem
# https://github.com/adamsanderson/open_gem/blob/master/lib/rubygems/commands/open_command.rb
#
def edit_file(file)
  editor = ENV['VISUAL'] || ENV['EDITOR']

  if !editor
    fail "Please set $VISUAL or $EDITOR to continue"
  else
    command_parts = Shellwords.shellwords(editor)
    command_parts << file
    success = system(*command_parts)
    if !success
      fail "Could not run '#{editor} #{file}'"
    end
  end
end
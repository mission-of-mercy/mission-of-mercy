require 'fileutils'

desc 'runs the tasks necessary to setup MoM'
task :setup do

  section "Configuration Files" do

    database_file = File.join(Rails.root, 'config', 'database.yml')
    mom_file      = File.join(Rails.root, 'config', 'mom.yml')

    unless File.exists?(database_file)
      FileUtils.cp(database_file + '.example', database_file)
      puts "Database config file created".color(:green)
      puts "Update #{database_file} and run `bundle exec rake setup` to continue".color(:red)
      `$EDITOR #{database_file}`
      exit
    else
      puts "Database config file already exists"
    end

    unless File.exists?(mom_file)
      FileUtils.cp(mom_file + '.example', mom_file)
      puts "MoM config file created".color(:green)
    else
      puts "MoM config file already exists"
    end

  end

  section "Database" do
    begin
      # Check if there are pending migrations
      Rake::Task["db:abort_if_pending_migrations"].invoke
      puts "Skip: Database already setup"
    rescue
      Rake::Task["db:setup"].invoke
    end
  end

  # Load the Rails Env now that the databases are setup
  Rake::Task["environment"].invoke

  section "Seed Data" do
    Rake::Task["db:seed"].invoke
    Rake::Task["procedures:import"].invoke
    Rake::Task["zip:import"].invoke
  end

  puts # Empty Line
  puts "==== Setup Complete ====".color(:green)
  puts # Empty Line

end

private

def section(description)
  puts # Empty Line
  puts description.underline
  puts # Empty Line
  yield
end

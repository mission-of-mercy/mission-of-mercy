require 'fileutils'
require 'highline'

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
      template     = ERB.new(File.read(mom_file + '.erb'))
      console      = HighLine.new
      default_path = Rails.root.join("tmp").to_s

      puts # Empty Line

      state = console.ask("In which state will you be running the clinic?") do |q|
        q.default = "CT"
      end

      dexis_path  = console.ask("Path to dexis folder")  {|q| q.default = default_path }
      backup_path = console.ask("Path to backup folder") {|q| q.default = default_path }

      File.open(mom_file, 'w') {|f| f.write(template.result(binding)) }

      puts "MoM config file created".color(:green)
    else
      puts "MoM config file already exists"
    end

  end

  section "Database" do
    begin
      # Check if there are pending migrations
      silence { Rake::Task["db:abort_if_pending_migrations"].invoke }
      puts "Skip: Database already setup"
    rescue Exception
      silence do
        Rake::Task["db:create"].invoke
        Rake::Task["db:schema:load"].invoke
      end
      puts "Database setup"
    end
  end

  # Load the Rails Env now that the databases are setup
  Rake::Task["environment"].invoke

  section "Seed Data" do
    Rake::Task["procedures:import"].invoke
    puts # Empty Line
    Rake::Task["db:seed"].invoke
    puts # Empty Line
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

def silence
  begin
    orig_stderr = $stderr.clone
    orig_stdout = $stdout.clone

    $stderr.reopen File.new('/dev/null', 'w')
    $stdout.reopen File.new('/dev/null', 'w')

    return_value = yield
  rescue Exception => e
    $stdout.reopen orig_stdout
    $stderr.reopen orig_stderr
    raise e
  ensure
    $stdout.reopen orig_stdout
    $stderr.reopen orig_stderr
  end

  return_value
end
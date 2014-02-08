require 'rails_setup'

namespace :setup do
  desc 'Generate dotenv file'
  setup_task :dotenv do
    find_or_create_file Rails.root.join('.env').to_s, "dotenv", true

    Dotenv.load

    done '.env'
  end
end

desc 'runs the tasks necessary to setup MoM'
setup_task :setup do
  puts
  puts "#{heart} Thanks for helping thousands of people get the dental care they need #{heart}"

  section 'Configuration Files' do
    Rake::Task['setup:dotenv'].invoke
  end

  section 'Database' do
    begin
      # Check if there are pending migrations
      silence { Rake::Task['db:abort_if_pending_migrations'].invoke }
      done 'Skip: Database already setup'
    rescue
      silence do
        Rake::Task['db:create'].invoke
        Rake::Task['db:schema:load'].invoke
      end
      done 'Database setup'
    end
  end

  # Load the Rails Env now that the databases are set up
  Rake::Task['environment'].invoke

  section 'Seed Data' do
    Rake::Task['db:seed'].invoke
    puts
    Rake::Task['procedures:import'].invoke
    puts

    if console.agree(%{Would you like to create sample data (Patients, Prescriptions, etc)?})
      Rake::Task['db:sample'].invoke
      puts
    end

    Rake::Task['zip:import'].invoke
  end

  puts
  puts %{#{'===='.color(:green)} Setup Complete #{'===='.color(:green)}}
  puts
end

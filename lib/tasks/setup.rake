require 'rails_setup'

namespace :setup do
  desc 'Generate a secret token file'
  setup_task :secret_token do
    secret_token = Rails.root.join('config', 'initializers', 'secret_token.rb').to_s

    unless File.exists?(secret_token)
      secret   = SecureRandom.hex(64)
      template = ERB.new(File.read(secret_token + '.example'))

      File.open(secret_token, 'w') { |f| f.write(template.result(binding)) }
    end

    done 'secret_token.rb'
  end
end

desc 'runs the tasks necessary to setup MoM'
setup_task :setup do

  puts
  puts "#{heart} Thanks for helping thousands of people get the dental care they need #{heart}"

  section 'Configuration Files' do
    database_file = File.join(Rails.root, 'config', 'database.yml')
    mom_file      = File.join(Rails.root, 'config', 'mom.yml')

    find_or_create_file database_file, 'database.yml', true

    done 'database.yml'

    unless File.exists?(mom_file)
      template     = ERB.new(File.read(mom_file + '.erb'))
      default_path = Rails.root.join("tmp").to_s

      puts

      state = console.ask('In which state will you be running the clinic?') do |q|
        q.default = 'CT'
      end

      dexis_path = console.ask('Path to dexis folder') { |q| q.default = default_path }
      backup_path = console.ask('Path to backup folder') { |q| q.default = default_path }

      File.open(mom_file, 'w') { |f| f.write(template.result(binding)) }
    end

    done 'mom.yml'

    Rake::Task['setup:secret_token'].invoke
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

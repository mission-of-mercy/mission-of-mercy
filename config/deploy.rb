set :application, "mom"

set :repository, "git@github.com:CTMissionofMercy/mission_of_mercy.git"
set :deploy_via, :remote_cache

set :scm, :git
set :user, "deploy"

set :deploy_to, "/home/deploy/#{application}"
set :use_sudo, false

server "mom.integrityss.com", :app, :web, :db, :primary => true

task :local do
  set :repository, %w(/Users/byron/code/personal/ct_mission_of_mercy)
  set :deploy_via, :copy
  set :copy_exclude, [".git"]
end

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after 'deploy:update_code' do
  { "database.yml" => "config/database.yml",
    "mom.yml"      => "config/mom.yml"}.
   each do |from, to|
     run "ln -nfs #{shared_path}/#{from} #{release_path}/#{to}"
   end
end

task :reset do
  # Prompt to make really sure we want to reset
  puts "\n\e[0;31m   ######################################################################" 
  puts "   \n                Are you REALLY sure you want to reset ?"
  puts "   \n                  Enter y/N + enter to continue\n   "
  puts "   ######################################################################\e[0m\n" 
  proceed = STDIN.gets[0..0] rescue nil 
  exit unless proceed == 'y' || proceed == 'Y'
  
  reset_sql = %{
    ALTER SEQUENCE patients_id_seq RESTART WITH 1;
    ALTER SEQUENCE patient_procedures_id_seq RESTART WITH 1;
    ALTER SEQUENCE patient_prescriptions_id_seq RESTART WITH 1;
    ALTER SEQUENCE patient_pre_meds_id_seq RESTART WITH 1;
    ALTER SEQUENCE surveys_id_seq RESTART WITH 1; }
  
  run "cd #{current_path} && ./script/console production" do |channel, stream, data|
    channel.send_data("Patient.destroy_all\n")
    channel.send_data("SupportRequest.destroy_all\n")
    channel.send_data("Survey.destroy_all\n")
    channel.send_data("Patient.connection.execute('#{reset_sql}')\n")
    channel.send_data("exit\n")
  end
end
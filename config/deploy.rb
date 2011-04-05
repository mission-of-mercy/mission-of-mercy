set :application, "mom"
set :repository,  "git@github.com:CTMissionofMercy/mission_of_mercy.git"

set :scm, :git
set :user, "deploy"

set :deploy_to, "/home/deploy/#{application}"

server "mom.integrityss.com", :app, :web, :db, :primary => true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after 'deploy:update_code' do
  run "ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml"
end
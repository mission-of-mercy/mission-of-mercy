require 'bundler/capistrano'

set :application, "momma"

set :repository, "git://github.com/mission-of-mercy/connecticut.git"
set :deploy_via, :remote_cache

set :scm, :git
set :user, "deploy"

set :deploy_to, "/home/deploy/#{application}"
set :use_sudo, false

server "momma.ct", :app, :web, :db, :primary => true

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after 'deploy:update_code' do
  { "database.yml"    => "config/database.yml",
    "mom.yml"         => "config/mom.yml",
    "secret_token.rb" => "config/initializers/secret_token.rb"}.
   each do |from, to|
     run "ln -nfs #{shared_path}/#{from} #{release_path}/#{to}"
   end
end

after "deploy", "deploy:migrate"
after "deploy", "deploy:cleanup"

load 'deploy/assets'

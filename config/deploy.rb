require 'bundler/capistrano'
require 'dotenv/capistrano'

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

after "deploy", "deploy:migrate"
after "deploy", "deploy:cleanup"

load 'deploy/assets'

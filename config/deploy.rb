require 'bundler/capistrano'
require 'dotenv/capistrano'
require './lib/capistrano_local_overrides'

set :application, "momma"

set :repository, "/Users/byron/code/mom/connecticut"
set :deploy_via, :copy

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

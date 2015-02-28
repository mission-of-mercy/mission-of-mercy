require 'bundler/capistrano'
require 'dotenv/capistrano'

set :application, "momma"

# For local, offline deploys
#
set :repository, "/Users/byron/code/mom/mission-of-mercy"
set :branch,     "connecticut"
set :deploy_via, :copy

set :scm, :git
set :user, "deploy"

set :deploy_to, "/home/deploy/#{application}"
set :use_sudo, false

server "momma.ct", :app, :web, :db, :primary => true

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    sudo "god restart momma"
  end
end

after "deploy", "deploy:migrate"
after "deploy", "deploy:cleanup"

load 'deploy/assets'

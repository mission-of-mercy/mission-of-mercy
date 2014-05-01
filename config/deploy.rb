require 'bundler/capistrano'

set :application, "momma"

set :repository, "git://github.com/mission-of-mercy/mission-of-mercy.git"
set :deploy_via, :remote_cache

set :scm, :git
set :user, "deploy"

if match = `git branch`.match(/\* (?<branch>\S+)\s/m)
  set :branch, match[:branch]
else
  set :branch, "master"
end

set :deploy_to, "/home/deploy/#{application}"
set :use_sudo, false

server "momma.ri", :app, :web, :db, :primary => true

after "deploy", "deploy:migrate"
after "deploy", "deploy:cleanup"
after "deploy" do
  sudo "god restart momma"
end

load 'deploy/assets'

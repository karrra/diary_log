# config valid only for current version of Capistrano
lock "3.11.0"

set :application, "diary_logs"
set :repo_url, "git@github.com:karrra/diary_logs.git"
set :deploy_to, "/home/deploy/diary_logs"

append :linked_files, "config/database.yml", "config/secrets.yml", "config/newrelic.yml"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets"

namespace :deploy do
  desc 'restart application'
  task :restart do
    invoke 'puma:stop'
    sleep 2
    invoke 'puma:start'
  end

  after :finishing, :cleanup
  after :finishing, :restart
end
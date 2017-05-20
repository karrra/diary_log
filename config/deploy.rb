# config valid only for current version of Capistrano
lock "3.7.2"

set :application, "diary_logs"
set :repo_url, "git@github.com:karrra/diary_logs.git"
set :deploy_to, "/var/www/diary_logs"

append :linked_files, "config/database.yml", "config/secrets.yml"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets"

after 'deploy:finishing', 'deploy:cleanup'
after 'deploy:publishing', 'deploy:restart'

namespace :deploy do
  task :restart do
    invoke 'unicorn:stop'
    sleep 5
    invoke 'unicorn:start'
  end
end

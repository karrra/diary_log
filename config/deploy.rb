# config valid only for current version of Capistrano
lock "3.7.2"

set :application, "my_bill"
set :repo_url, "git@github.com:karrra/my_bill.git"
set :deploy_to, "/var/www/my_bill"

append :linked_files, "config/database.yml", "config/secrets.yml"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets"

after 'deploy:finishing', 'deploy:cleanup'
after 'deploy:publishing', 'deploy:restart'

namespace :deploy do
  task :restart do
    invoke 'unicorn:legacy_restart'
  end
end

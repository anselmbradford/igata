require "bundler/capistrano"

default_run_options[:pty] = true
ssh_options[:compression] = 'none'

set :application, 'igata'
set :repository,  'git@github.com:dockyard/igata.git'

set :scm, :git

role :web, 'igata.io'
role :app, 'igata.io'
role :db,  'igata.io', :primary => true # This is where Rails migrations will run

set :user, 'deploy'
set :use_sudo, false

set :deploy_to, '/var/www/igata-production'

before 'deploy:assets:precompile', 'symlink:database'
before 'deploy:assets:precompile', 'symlink:settings'
before 'deploy:assets:precompile', 'symlink:env'
before 'deploy:assets:precompile', 'symlink:uploads'
after  'deploy:restart',           'foreman:export'
after  'deploy:restart',           'foreman:restart'

namespace :symlink do
  task :database do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  task :uploads do
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
  end

  task :settings do
    run "ln -nfs #{shared_path}/config/settings.yml #{release_path}/config/settings.yml"
  end

  task :env do
    run "ln -nfs #{shared_path}/config/env #{release_path}/.env" 
  end
end

namespace :foreman do
  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export, :roles => :app do
    run "cd #{release_path} && sudo bundle exec foreman export upstart /etc/init -a #{application} -u #{user} -l #{shared_path}/log"
  end

  desc "Start the application services"
  task :start, :roles => :app do
    sudo "start #{application}"
  end

  desc "Stop the application services"
  task :stop, :roles => :app do
    sudo "stop #{application}"
  end

  desc "Restart the application services"
  task :restart, :roles => :app do
    run "sudo start #{application} || sudo restart #{application}"
  end
end

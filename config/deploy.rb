# set :bundle_cmd, "/usr/local/rvm/gems/ruby-1.9.3-p286@global/bin/bundle"
# set :bundle_dir, "/usr/local/rvm/gems/ruby-1.9.3-p286"
# set :bundle_dir,     ""         # install into "system" gems
# set :bundle_flags,   "--quiet"  # no verbose output
# set :bundle_without, []         # bundle all gems (even dev & test)
require 'bundler/capistrano'
require "rvm/capistrano"


set :rvm_ruby_string, 'ruby-1.9.3-p286@global'
set :rvm_type, :system
set :application, "newclass.org"
set :scm, :git
set :repository,  "git@github.com:jexchan/re-education.git"
set :branch, 'master'

# set :default_environment, {
#   'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
# }

# set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")
# set :rvm_type, :system
# set :rvm_bin_path, "$HOME/bin"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :user, "root"
set :group, "root"
set :deploy_to, "/var/www/newclass.org"
# set :use_sudo, false

set :deploy_via, :remote_cache
# set :deploy_via, :copy
# set :deploy_strategy, :export
set :keep_release, 5

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

# Target ruby version
role :web, "42.121.105.39"                          # Your HTTP server, Apache/etc
role :app, "42.121.105.39"                          # Your HTTP server, Apache/etc
role :db, "42.121.105.39"                          # Your HTTP server, Apache/etc

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
    # run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  desc "Copy the database.yml file into the latest release"
  task :copy_in_database_yml do
    run "rm #{release_path}/config/database.yml"
    run "cp #{shared_path}/config/database.yml #{release_path}/config/"
    # run "cp #{shared_path}/config/database.yml #{latest_release}/config/"
  end
end

# before "deploy:assets:precompile", "deploy:copy_in_database_yml"
after "bundle:install", "deploy:copy_in_database_yml"

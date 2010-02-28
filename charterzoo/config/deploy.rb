set :application, "cz"

set :user, 'cheri'
set :use_sudo, false
set :deploy_via, :remote_cache

set :scm, :git
set :repository,  "git@github.com:liquidrails/RailsZoo.git"
#set :repository,  "https://github.com/liquidrails/RailsZoo"
set :scm_username, "liquid_rails@yahoo.com"
set :scm_passphrase, "Purple7"
set :git_shallow_clone, 1

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "localhost"                          # Your HTTP server, Apache/etc
role :app, "localhost"                           # This may be the same as your `Web` server
role :db,  "localhost" , :primary => true # This is where Rails migrations will run

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

set :deploy_to, "/web"

 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end

# config valid for current version and patch releases of Capistrano
lock "~> 3.19.2"

set :application, 'qna'
set :repo_url, 'git@github.com:VorobevaKseniia/qna.git'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deployer/qna3'
set :deploy_user, 'deployer'

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/credentials/production.key', 'config/credentials/production.yml.enc'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'storage'


# Default value for default_env is {}
set :default_env, { PATH: "$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH:node_modules/.bin" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }

after 'deploy:publishing', 'unicorn:restart'

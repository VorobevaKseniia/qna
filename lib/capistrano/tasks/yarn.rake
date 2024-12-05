namespace :deploy do
  desc "Precompile assets locally"
  task :assets_precompile do
    on roles(:app) do
      within release_path do
        execute :yarn, 'install --production=false'
        execute 'node_modules/.bin/webpack', '--config', 'config/webpack/production.js'
      end
    end
  end

  before 'deploy:assets:precompile', 'deploy:assets_precompile'
end

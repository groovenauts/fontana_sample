# -*- coding: utf-8 -*-
set :application, "fontana_sample"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# role :web と role :db は使用しません
# role :app もmultistage対応するので、ここでは設定しません。
# role :app, "your app-server here"

# scm
set :repository,  "git@github.com:groovenauts/fontana_sample.git"
set :scm_verbose,    true
set :default_branch, "master"

# この変数を使うタスクを実行する際には cap -s branch=<SHA> ... という風に
# VersionSetのdeploy_keyが指定されることになります
set(:branch){ raise "branch (that means branch, tag and SHA for git) must be given" }

# deploy
set :deploy_via,     :copy

# 世代管理
set :keep_releases, 3
after "deploy:update", "deploy:cleanup"

# public以下のディレクトリがないことを定義する
set :public_children, []

namespace :deploy do
  desc "set sudo enable"
  task :enable_sudo do
    set :use_sudo, true
  end

  desc "set sudo disable"
  task :disable_sudo do
    set :use_sudo, false
  end

  task :fix_permissions, :roles => [fetch(:role, :app)] do
    run "#{try_sudo} chown -R #{user}:#{user} #{deploy_to}"
  end
end

before "deploy:setup", "deploy:enable_sudo"
after  "deploy:setup", "deploy:fix_permissions"
after  "deploy:setup", "deploy:disable_sudo"

#
# whenever defines crontab
#
# see https://github.com/javan/whenever
#     https://github.com/javan/whenever/blob/master/lib/whenever/capistrano/recipes.rb
#
set(:whenever_roles)        { :gotool }
set(:whenever_options)      { {:roles => fetch(:whenever_roles)} }
set(:whenever_command)      { "bundle install --path vendor/bundle --without development test && bundle exec whenever" }
set(:whenever_identifier)   { fetch :application }
set(:whenever_environment)  { fetch :rails_env, "production" }
set(:whenever_variables)    { "environment=#{fetch :whenever_environment}" }
set(:whenever_update_flags) { "--update-crontab #{fetch :whenever_identifier} --set #{fetch :whenever_variables}" }
set(:whenever_clear_flags)  { "--clear-crontab #{fetch :whenever_identifier}" }

require "whenever/capistrano/recipes"


namespace :deploy do
  task :fix_permissions, :roles => [fetch(:role, :app)] do
    run "#{try_sudo} chown -R #{user}:#{user} #{deploy_to}"
  end

  after "deploy:setup", "deploy:setup_deploy_config_file"
  task :setup_deploy_config_file, :roles => [fetch(:role, :app)] do
    run("mkdir -p '#{shared_path}/config/deploy'")
    put(IO.read("config/deploy/#{stage}.yml"), "#{shared_path}/config/deploy/#{stage}.yml", :mode => 0644)
  end

  after "deploy:setup", "deploy:setup_copy_dir"
  task :setup_copy_dir, :roles => [fetch(:role, :gotool)] do
    run_locally("mkdir -p '#{copy_dir}'")
  end
  after "deploy:setup", "deploy:setup_remote_copy_dir"
  task :setup_remote_copy_dir, :roles => [fetch(:role, :gotool)] do
    run("mkdir -p '#{remote_copy_dir}'")
  end

  after "deploy:symlinks", "deploy:symlink_deploy_config_file"
  task :symlink_deploy_config_file, roles: fetch(:role, :app) do
    run "/bin/rm -f '#{release_path}/config/deploy/#{stage}.yml'"
    run "ln -nfs '#{shared_path}/config/deploy/#{stage}.yml' '#{release_path}/config/deploy/#{stage}.yml'"
  end

  after  "deploy:setup", "deploy:setup_shared" # fix_permissions の後にしないと権限がなくて失敗するので注意

  desc "setup shared directories"
  task :setup_shared, :roles => [fetch(:role, :app)] do
    run("mkdir -p '#{shared_path}/config'")

    # config/deploy/<stage>/config/xxx.ymlがあればそれを読みます
    %w[config/mongoid.yml config/redis.yml].each do |config_path|
      path = File.expand_path("../deploy/#{stage}/#{config_path}", __FILE__)
      path = File.expand_path("../../#{config_path}.example", __FILE__) unless File.readable?(path)
      put(IO.read(path), "#{shared_path}/#{config_path}", :mode => 0644)
    end

    ## railsのassetsではなく、fontanaの（保護つきではない）アセット
    run("mkdir -p '#{shared_path}/fontana-assets'")
  end


  desc "Make symlink for config_file"
  task :symlinks, :roles => [fetch(:role, :app)] do
    %w[config/mongoid.yml config/redis.yml].each do |path|
      run "/bin/rm -f '#{release_path}/#{path}'"
      run "ln -nfs '#{shared_path}/#{path}' '#{release_path}/#{path}'"
    end

    ## FONTANA_FILE_STORAGE_URL_PREFIX は http://FQDN/a/ のように、 path の部分が /a/ であることを前提としている
    run "if [ -n \"$FONTANA_FILE_STORAGE_FILE_PATH\" ]; then ln -nfs \"$FONTANA_FILE_STORAGE_FILE_PATH\" '#{release_path}/public/a'; else ln -nfs '#{shared_path}/fontana-assets' '#{release_path}/public/a'; fi"
  end

  #after  "deploy:finalize_update", "deploy:symlinks"
  before "bundle:install", "deploy:symlinks"

end

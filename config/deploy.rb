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

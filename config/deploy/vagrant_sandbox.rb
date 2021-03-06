# -*- coding: utf-8 -*-
# Nifty cloud 向けのデプロイファイルです。主に(お客様)開発環境の構築に用います。
#
# サービスを動かすユーザ名等を別の設定ファイルから読み込むようにしてします。
# これは、タイトルによって、ユーザ名、deploy_toが異なるため、
# このファイルに記述するべきものではないためです。
#
deploy_config = YAML.load_file("config/deploy/#{stage}.yml")

set :user,        deploy_config['user']       # デプロイするユーザ
set :ssh_options, {
  :forward_agent => true,
  :keys => [
    "#{ENV['HOME']}/.ssh/fontana_dev_key", # vagrant sandboxにデプロイなどをする際に使用
    "#{ENV['HOME']}/.ssh/id_rsa"           # passengerのプロセスからcapコマンドを使う場合に使用
  ]
  #:port          => 58123,
}

set :application,    "fontana_sample"

# scm
# 運営ツールからデプロイする際には、gitを使用せず、workspaces/runtimeを元にデプロイします
# set :scm, :git
# set :repository,     "git@github.com:groovenauts/fontana_sample.git"
# set :default_branch, "master"
set :scm, :none
set :repository, deploy_config["workspaces"]["runtime"]

set :scm_verbose,    true
# 実行時に -s branch=xxxx でブランチ名を指定してください
# set :branch do
#   tag = Capistrano::CLI.ui.ask "branch or tag : [#{default_branch}] "
#   tag = default_branch if tag.empty?
#   tag
# end

# deploy
set :deploy_via,     :copy # Projectが生成するconfig/fontana.yml もコピーするので、copyが一番楽
## :deploy_to は初期値として { "/u/apps/#{application}" } が入っているので、
##   -s deploy_to 指定時はオプションの値、省略時は deploy_config (yaml) の値、
## という指定方法ができない。-s で指定する場合は -s override_deploy_to で指定することにする
set :deploy_to      , fetch(:override_deploy_to, deploy_config['deploy_to'])
set :copy_dir       , "/tmp/copy_dir"
set :remote_copy_dir, "/tmp/remote_copy_dir"

set :deploy_env,     "production"
set :rails_env,      "production"


# Configサーバ
set :config_server_path,       fetch(:config_server_path,          deploy_config['config_server']['path'])
set :config_server_repository, fetch(:config_server_repository,    deploy_config['config_server']['repository'])
set :config_server_branch,     fetch(:config_server_branch,        deploy_config['config_server']['branch'])

# workspaces
set :workspaces_scm    , deploy_config["workspaces"]["scm"]
set :workspaces_runtime, deploy_config["workspaces"]["runtime"]

set :keep_releases, 3
after "deploy:update", "deploy:cleanup"

# BRIDGE との接続する環境の場合、接続のためのキーの復号のため、
# 非公開リポジトリである groovegun にある gndecrypt が必要となります。
# after "deploy:setup", "deploy:gndecrypt"

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
end

# roles
domain = fetch(:domain, deploy_config["host"] || "sandbox")
role :web, domain
role :app, domain
role :db , domain, :primary => true
role :gotool, domain

# -*- coding: utf-8 -*-
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


# deploy
# set :deploy_via,     :copy # Projectが生成するconfig/fontana.yml もコピーするので、copyが一番楽
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

set :keep_releases, 3
after "deploy:update", "deploy:cleanup"

# roles
domain = fetch(:domain, deploy_config["host"] || "sandbox")
role :web, domain
role :app, domain
role :db , domain, :primary => true

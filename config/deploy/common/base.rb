# -*- coding: utf-8 -*-

# このファイルは各デプロイ対象に共通なタスクをまとめたものです。
# capistranoはmultistageの設定を config/deploy/*.rb に該当するファイル名から
# 取得するため、 config/deploy/common.rb や config/deploy/base.rb は純粋な
# 共通処理としてではなく、ひとつのステージとして解釈されてしまうので、 config/deploy/common
# ディレクトリにこのファイルを配置しております。
# https://github.com/capistrano/capistrano/blob/legacy-v2/lib/capistrano/ext/multistage.rb#L11

#
# Rails.rootで実行することを前提にしています。
#
require 'erb'
require 'yaml'
deploy_config_filepath = "config/deploy/#{stage}.yml"
erb = ERB.new(IO.read(deploy_config_filepath))
erb.filename = deploy_config_filepath
deploy_config = YAML.load(erb.result, deploy_config_filepath)

## [運営ツール->APIサーバ] 運営ツールから、APIサーバ群すべてへデプロイするための設定を行うタスク
desc "select deploy target: deploy to all API servers"
task :"@apisrv" do
end

deploy_config['apisrv']['servers'].keys.each do |host|
  after :"@apisrv", :"@#{host}"
end

## [運営ツール->APIサーバ] 運営ツールから、APIサーバ群ごとにデプロイするための設定を行うタスク
deploy_config['apisrv']['servers'].values.map{|s| s['group']}.each do |grp|
  desc "select deploy target: deploy to API servers group #{grp}"
  task :"@apisrv/group-#{grp}" do
  end
end

deploy_config['apisrv']['servers'].keys.each do |host|
  after :"@apisrv/group-#{deploy_config['apisrv']['servers'][host]['group']}", :"@#{host}"
end

## [運営ツール->APIサーバ] 運営ツールから、各APIサーバにデプロイするための設定を行うタスク
deploy_config['apisrv']['servers'].keys.each do |host|
  desc "select deploy target: deploy to #{host}"
  task :"@#{host}" do
    role :app, host
    role :apisrv, host
  end

  after :"@#{host}", :"@apisrv/common"
end

## [運営ツール->APIサーバ] APIサーバにデプロイするための設定のうち共通部分
task :"@apisrv/common" do
  set :user,       deploy_config['apisrv']['user']
  set :deploy_to,  deploy_config['apisrv']['workspaces']['runtime'].sub(%r{/current\Z}, '')
  ## apisrv 以外と混ざらないようにする
  set_deploy_target :"@apisrv"
end




## [運営ツール->運営ツール] 運営ツールから、運営ツール群すべてへデプロイするための設定を行うタスク
desc "select deploy target: deploy to all GO Tools"
task :"@gotool" do
end

deploy_config['gotool']['servers'].keys.each do |host|
  after :"@gotool", :"@#{host}"
end

## [運営ツール->運営ツール] 運営ツールから、各運営ツールにデプロイするための設定を行うタスク
deploy_config['gotool']['servers'].keys.each do |host|
  desc "select deploy target: deploy to #{host}"
  task :"@#{host}" do
    role :app, host
    role :gotool, host
  end

  after :"@#{host}", :"@gotool/common"
end

## [運営ツール->運営ツール] 運営ツールにデプロイするための設定のうち共通部分
task :"@gotool/common" do
  set :user,       deploy_config['gotool']['user']
  set :deploy_via,     :copy
  # set :deploy_to,  deploy_config['gotool']['workspaces']['runtime'].sub(%r{/current\Z}, '')
  set :deploy_to ,  "/tmp/gotool_for_whenever"
  set :copy_dir  ,  "/tmp/copy_dir"
  ## gotool 以外と混ざらないようにする
  set_deploy_target :"@gotool"
end





## デプロイ先サーバ・ディレクトリ選択時に異なる種類のデプロイ対象を選択できないようにする
## (cap vagrant @apisrv-a01 @gotool01 deploy:update などをできないようにする)
def set_deploy_target(tgt)
  case selected = fetch(:selected_deploy_target, nil)
  when nil
    set :selected_deploy_target, tgt
  when tgt
    # OK, do nothing
  else
    raise "already selected deploy target: #{selected}"
  end
end

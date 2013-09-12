# -*- coding: utf-8 -*-
require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

# master_diffs のテストは spec/fixtures/version_sets.yml.erb の状態 (dm: 2.2) を前提としているので、フィクスチャを指定しています。
ENV['GSS_VERSION_SET_FIXTURE_FILEPATH'] ||= File.expand_path("../spec/fixtures/version_sets.yml.erb", __FILE__)

# この環境変数FONTANA_VERSIONの設定は、fontanaの開発に関係するfontana_sample独自の設定ですので、各タイトルでは削除してください。
Dir.chdir(File.expand_path("..", __FILE__)) do
  unless `git status`.scan(/On branch\s*(.+)\s*$/).flatten.first == "master"
    # 環境変数FONTANA_VERSIONを設定することで、FONTANA_VERSIONファイルの内容は無視されます。
    ENV['FONTANA_VERSION'] ||= ""
    ENV['FONTANA_BRANCH'] ||= "develop"
  end
end

require 'fontana_client_support'
FontanaClientSupport.configure do |c|
  c.root_dir = File.expand_path("..", __FILE__)
  c.deploy_strategy = (ENV['SYNC_DIRECTLY'] =~ /^true$|^on$/i) ? :sync : :scm
end

require 'fontana_client_support/tasks'


task :default => :spec_with_server_daemons

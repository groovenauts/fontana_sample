# -*- coding: utf-8 -*-
# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

require 'tengine/support/yaml_with_erb'
RUNTIME_CONFIG = YAML.load_file_with_erb(File.expand_path("../fontana.yml", __FILE__))


# set :path instead of Whenever.path
set :path, RUNTIME_CONFIG["gotool"]["path"]
set :app_dir, RUNTIME_CONFIG["workspaces"]["runtime"]

# set runner template instead of default template using runner_for_app
job_type :runner, "export EXECUTION_KEY=`date +'%Y-%m-%dT%H:%M:00%z'` APP_DIR=:app_dir && cd :path && bundle exec rails runner -e :environment 'Fontana::Batch.run(\":task\", ENV[\"EXECUTION_KEY\"], app_dir: ENV[\"APP_DIR\"])' :output"

# ローカルで実行する際には以下のように実行してください
# $ cd path/to/project
# $ export export APP_DIR=$PWD
# $ cd vendor/fontana && bundle exec rails runner $APP_DIR/app/batches/calc_player_count_per_item_and_its_count.rb && cd -
#
# より本番に近い動作をさせる場合には以下のようにしてください。
# $ cd path/to/project
# $ export export APP_DIR=$PWD
# $ cd vendor/fontana && bundle exec rails runner 'Fontana::Batch.run("app/batches/calc_player_count_per_item_and_its_count.rb")' && cd -

every "*/10 * * * *" do # 10分おき
  runner "app/batches/calc_player_count_per_item_and_its_count.rb"
end

every "*/10 * * * *" do # 10分おきに有効化予約の確認と実行
  rake "version_set:activate_planned"
end

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
RUNTIME_CONFIG = YAML.load_file_with_erb(File.expand_path("../runtime.yml", __FILE__))

open("/tmp/config_schedule.log", "a") do |f|
  f.puts("#{__FILE__}##{__LINE__}")
  f.puts("Dir.pwd: " << Dir.pwd.inspect)
  f.puts("\n  " << caller.join("\n  "))
end

# set :path instead of Whenever.path
set :path, RUNTIME_CONFIG["gotool"]["path"]

# set runner template instead of default template using runner_for_app
job_type :runner, "cd :path && script/rails runner -e :environment ':task' :output"

every "*/10 * * * *" do # 10分おき
  runner "app/batches/calc_player_count_per_item_and_its_count.rb"
end

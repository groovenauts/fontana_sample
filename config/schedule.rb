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

# set :path, Whenever.path
set :path, RUNTIME_CONFIG["gotool"]["path"]

module Whenever
  def self.path
    # Dir.pwd
    RUNTIME_CONFIG["gotool"]["path"]
  end
end

every "*/10 * * * *" do # 10分おき
  runner "app/batches/calc_player_count_per_item_and_its_count.rb"
end

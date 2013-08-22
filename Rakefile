# -*- coding: utf-8 -*-
require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

require 'fontana_client_support'
FontanaClientSupport.configure do |c|
  c.root_dir = File.expand_path("..", __FILE__)
  c.deploy_strategy = (ENV['SYNC_DIRECTLY'] =~ /^true$|^on$/i) ? :sync : :scm
end

require 'fontana_client_support/tasks'



task :default => :spec_with_server_daemons

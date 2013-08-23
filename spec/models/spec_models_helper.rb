require 'spec_helper'

# $LOAD_PATH << File.expand_path("../../../app/modes", __FILE__)

require 'active_support/dependencies'
ActiveSupport::Dependencies.autoload_paths << File.expand_path("../../../app/models", __FILE__)

require File.expand_path('../../spec_helper', __FILE__)

if ENV['SYNC_DIRECTLY'] =~ /yes|on|true/i
  Fontana::CommandUtils::system!("rake deploy:sync:update")
end

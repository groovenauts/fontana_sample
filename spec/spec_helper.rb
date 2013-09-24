# -*- coding: utf-8 -*-

if ENV['SYNC_DIRECTLY'] =~ /yes|on|true/i
  unless system("rake deploy:sync:update")
    raise "rake deploy:sync:update ERROR!"
  end
end
require 'libgss'
require 'mongoid'

require 'fontana_client_support'

Mongoid.load!(File.expand_path("../../config/fontana_mongoid.yml", __FILE__), :test)

Dir[File.expand_path("../support/auto/**/*.rb", __FILE__)].each {|f| require f}

require 'active_support/dependencies'

d = File.expand_path("../support/models", __FILE__)
"Directory not found: #{d.inspect}" unless Dir.exist?(d)
ActiveSupport::Dependencies.autoload_paths << d


require 'factory_girl'
FactoryGirl.find_definitions

RSpec.configure do |config|

  # iOS開発環境が整っていない場合、SSLで接続する https://sandbox.itunes.apple.com/verifyreceipt が
  # オレオレ証明書を使っているので、その検証をができなくてエラーになってしまいます。
  # 本来ならば、信頼する証明書として追加する方が良いと思われますが、
  # ( http://d.hatena.ne.jp/komiyak/20130508/1367993536 )
  # 証明書自身の検証はローカルの開発環境で行うことができるので、ここでは単純に検証をスキップする
  # ように設定してしまいます。
  require 'openssl'
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

  config.include FactoryGirl::Syntax::Methods
end

# -*- coding: utf-8 -*-
load 'deploy'
# Uncomment if you are using Rails' asset pipeline
# load 'deploy/assets'
load 'config/deploy' # remove this line to skip loading any of the default tasks

# 直接bundle installする必要はないので、bundler/capistranoも不要です
# http://bundler.io/v1.3/deploying.html
require "bundler/capistrano"

# デフォルトステージを決めることはできないので、敢えて設定しません。
# また以下のように設定すると、-S や -s のどちらを使っても例外が発生してしまいます。
# set(:default_stage){ raise "default_stage must be given" }

require 'capistrano/ext/multistage'

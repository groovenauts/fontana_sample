# -*- coding: utf-8 -*-
require 'spec_helper'

describe "master_diffs" do

  # このテストは spec/fixtures/version_sets.yml.erb の状態 (dm: 2.2) を前提としています。
  # 実行の際は以下のように環境変数を設定してください。
  # export GSS_VERSION_SET_FIXTURE_FILEPATH=spec/fixtures/version_sets.yml.erb

  let(:network){ new_network.tap{|n| n.login.should == true } }
  let(:request){ network.new_action_request }

  context "01_basic" do
    fixtures "01_basic"

    context "1.2" do
      before{ request.master_diffs("GreetingTemplate" => "1.2"); request.send_request }
      it do
        request.outputs.length.should == 1
        request.outputs.first.tap do |o|
          o["error"].should == nil
          o["result"].should == [{
            "name" => "GreetingTemplate",
            "origin_version" => nil,
            "version" => "2.2",
            "diff_content" => {
              "added_documents" => [
                { "greeting_cd" => 1, "message" => "おはようございます ^ ^"},
                { "greeting_cd" => 2, "message" => "こんにちはー！"},
                { "greeting_cd" => 3, "message" => "こんばんはー！"},
                { "greeting_cd" => 5, "message" => "いただきます"},
                { "greeting_cd" => 6, "message" => "ごちそうさま"},
              ],
              "updated_documents" => [],
              "deleted_documents" => [],
            }
          }]
        end
      end
    end


    context "2.0" do
      before{ request.master_diffs("GreetingTemplate" => "2.0"); request.send_request }
      it do
        request.outputs.length.should == 1
        request.outputs.first.tap do |o|
          o["error"].should == nil
          o["result"].should == [{
            "name" => "GreetingTemplate",
            "origin_version" => "2.0",
            "version" => "2.2",
            "diff_content" => {
              "added_documents" => [
                  { "greeting_cd" => 5, "message" => "いただきます"},
                  { "greeting_cd" => 6, "message" => "ごちそうさま"},
                ],
              "updated_documents" => [
                  { "greeting_cd" => 1, "message" => "おはようございます ^ ^"},
                ],
              "deleted_documents" => [
                  { "greeting_cd" => 4},
                ],
            }
          }]
        end
      end
    end
  end

end

# -*- coding: utf-8 -*-
require 'spec_helper'

describe "StatusRubyStoredScript" do

  describe :apply_status do

    let(:network){ new_network("1000001").tap{|n| n.login.should == true } }
    let(:request){ network.new_action_request }

    describe "存在しないステータスコード" do
      # ディレクトリを指定したフィクスチャのロード
      fixtures "simple"

      # ファイルを単独で指定したフィクスチャのロード（v0.3.0では未サポート）
      # fixtures "simple/GameData.yml"

      before do
        request.execute("StatusRubyStoredScript", "apply_status", status_cd: "9999")
        request.send_request
      end
      it do
        request.outputs.length.should eq(1)
        request.outputs.first.tap do |o|
          o["error"].should be_nil
          o["result"].should == "Status is invalid!"
        end
      end
    end

    describe "存在するステータスコード" do
      # ディレクトリを指定したフィクスチャのロード
      fixtures "simple"

      # ファイルを単独で指定したフィクスチャのロード（v0.3.0では未サポート）
      # fixtures "simple/GameData.yml"

      before do
        request.execute("StatusRubyStoredScript", "apply_status", status_cd: "1001")
        request.get_by_game_data
        request.send_request
      end
      it do
        request.outputs.length.should eq(2)
        request.outputs.first.tap do |o|
          o["error"].should be_nil
          o["result"].should == "You became a 毒 state"
        end
        request.outputs.last.tap do |o|
          o["error"].should be_nil
          o["result"].should_not be_nil
          o["result"]["content"]["status"].include?(1001).should be_true  # 1001のステータスが付与されている
        end
      end
    end
  end


  describe :recovery_status do

    # 毒消し草を3つもっていて毒状態のプレイヤー
    let(:network){ new_network("1000010").tap{|n| n.login.should == true } }
    let(:request){ network.new_action_request }

    describe "存在しないステータスコード" do
      # ディレクトリを指定したフィクスチャのロード
      fixtures "simple"

      # ファイルを単独で指定したフィクスチャのロード（v0.3.0では未サポート）
      # fixtures "simple/GameData.yml"

      before do
        request.execute("StatusRubyStoredScript", "recovery_status", status_cd: "9999")
        request.send_request
      end
      it do
        request.outputs.length.should eq(1)
        request.outputs.first.tap do |o|
          o["error"].should be_nil
          o["result"].should == "Status is invalid!"
        end
      end
    end

    describe "存在するステータスコード" do
      # ディレクトリを指定したフィクスチャのロード
      fixtures "simple"

      # ファイルを単独で指定したフィクスチャのロード（v0.3.0では未サポート）
      # fixtures "simple/GameData.yml"

      before do
        request.execute("StatusRubyStoredScript", "recovery_status", status_cd: "1001")
        request.send_request
      end
      it do
        request.outputs.length.should eq(1)
        request.outputs.first.tap do |o|
          o["error"].should be_nil
          o["result"].should == "Recovery a 毒 state"
        end
      end
    end

    describe "use_item経由" do
      # ディレクトリを指定したフィクスチャのロード
      fixtures "simple"

      # ファイルを単独で指定したフィクスチャのロード（v0.3.0では未サポート）
      # fixtures "simple/GameData.yml"

      before do
        request.execute("ItemRubyStoredScript", "use_item", item_cd: "20014")
        request.get_by_game_data
        request.send_request
      end
      it do
        request.outputs.length.should eq(2)
        request.outputs.first.tap do |o|
          o["error"].should be_nil
          o["result"].should == "Recovery a 毒 state"
        end
        request.outputs.last.tap do |o|
          o["error"].should be_nil
          o["result"].should_not be_nil
          o["result"]["content"]["status"].include?(1001).should be_false  # 1001のステータスが付与されている
        end
      end
    end
  end
end


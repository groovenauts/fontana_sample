# -*- coding: utf-8 -*-
require File.expand_path('../spec_scripts_helper', __FILE__)

describe "RubyStoredScript" do

  context "何も課金アイテムを持っていない人" do

    before :all do
      Player.delete_all
      GameData.delete_all
      @player = FactoryGirl.create :player07
      @game_data = FactoryGirl.create :game_data07
    end
    let(:cxt){ Fontana::Action::Context.new("test"){ @player } }
    let(:receipt_data){ IO.read(File.expand_path("../ruby_stored_script_spec/receipt_stone1", __FILE__)) }

    describe "before_purchase" do
      it do
        r = cxt.get("name" => "GameData")
        expect(r["content"]["purchase_items"]).to be_nil
      end
    end

    describe "stone1" do
      it do
        r = cxt.execute("name" => "RubyStoredScript", "key" => "process_receipt", "args" => {receipt_data: receipt_data})
        expect(r).to eq "OK"

        r = cxt.get("name" => "GameData")
        expect(r["content"]["purchase_items"]).to eq({"jp__dot__groovenauts__dot__libgss__dot__cocos2dx__dot__sample1__dot__stone1" => 1})
      end
    end
  end

  context "既に課金アイテムを持っている人" do

    before :all do
      Player.delete_all
      GameData.delete_all
      @player = FactoryGirl.create :player01
      @game_data = FactoryGirl.create :game_data01
    end
    let(:cxt){ Fontana::Action::Context.new("test"){ @player } }
    let(:receipt_data){ IO.read(File.expand_path("../ruby_stored_script_spec/receipt_stone1", __FILE__)) }

    describe "before_purchase" do
      it do
        r = cxt.get("name" => "GameData")
        expect(r["content"]["purchase_items"]).to eq({"jp__dot__groovenauts__dot__libgss__dot__cocos2dx__dot__sample1__dot__stone1" => 10})
      end
    end

    describe "stone1" do
      it do
        r = cxt.execute("name" => "RubyStoredScript", "key" => "process_receipt", "args" => {receipt_data: receipt_data})
        expect(r).to eq "OK"

        r = cxt.get("name" => "GameData")
        expect(r["content"]["purchase_items"]).to eq({"jp__dot__groovenauts__dot__libgss__dot__cocos2dx__dot__sample1__dot__stone1" => 11})
      end
    end
  end

end

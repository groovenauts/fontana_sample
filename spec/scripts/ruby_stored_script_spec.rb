# -*- coding: utf-8 -*-
require File.expand_path('../spec_scripts_helper', __FILE__)

describe "RubyStoredScript" do

  before do
    Player.delete_all
    GameData.delete_all
    @player = FactoryGirl.create(:player07)
    @game_data = FactoryGirl.create(:game_data07)
  end

  let(:cxt){ Fontana::Action::Context.new("test"){ @player } }

  describe :echo do
    let(:argh){ {"foo" => {"bar" => "baz"} } }
    it do
      r = cxt.execute("name" => "RubyStoredScript", "key" => "echo", "args" => argh)
      expect(r).to eq({:echo => argh})
    end
  end

  describe :use_item do

    # ファイルを単独で指定したフィクスチャのロード（v0.3.0では未サポート）
    # fixtures "simple/GameData.yml"
    it do
      r = cxt.execute("name" => "ItemRubyStoredScript", "key" => "use_item", "args" => {item_cd: "20001"})
      expect(r).to eq "recovery hp 14points"

      r = cxt.get("name" => "GameData")
      expect(r["content"]["hp"]).to eq 15 # HPが回復している
      expect(r["content"]["items"]["20001"]).to eq 2 # 一つ減っている
    end
  end

end

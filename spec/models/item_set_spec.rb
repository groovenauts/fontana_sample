# -*- coding: utf-8 -*-
require File.expand_path('../spec_models_helper', __FILE__)

describe FontanaSample::ItemSet do

  describe "#to_hash" do
    it "文字列の場合、そのアイテムが1個と解釈される" do
      FontanaSample::ItemSet.to_hash("potion").should == {"potion" => 1}
    end
    it "配列の場合、各要素がアイテム1個と解釈される" do
      FontanaSample::ItemSet.to_hash(["potion", "elixir"]).should == {"potion" => 1, "elixir" => 1}
    end
    it "Hashの場合、そのまま" do
      FontanaSample::ItemSet.to_hash({"potion" => 4, "elixir" => 2}).should == {"potion" => 4, "elixir" => 2}
    end
  end

end

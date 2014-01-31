# -*- coding: utf-8 -*-
require File.expand_path('../spec_scripts_helper', __FILE__)

describe "CarParts" do

  let(:network){ new_network("1000007").tap{|n| n.login.should == true } }
  let(:request){ network.new_action_request }

  fixtures "car_parts" # フィクスチャのロード

  describe :stocks do

    context "引数なし" do
      let(:argh){}

      before do
        request.execute("CarParts", "stocks", argh)
        request.send_request
      end

      it do
        request.outputs.length.should == 1
        request.outputs.first["error"].nil?.should  == false
        request.outputs.first["result"].nil?.should == true
      end
    end

    context "該当部品なし" do
      let(:argh){ {"car_cd" => "1001", "category_cd" => "3"} }

      before do
        request.execute("CarParts", "stocks", argh)
        request.send_request
      end

      it do
        request.outputs.length.should == 1
        request.outputs.first["result"].should == []
      end
    end

    context "該当部品あり" do
      context "在庫数がゼロのものがある場合" do
        let(:argh){ {"car_cd" => "1005", "category_cd" => "1"} }

        before do
          request.execute("CarParts", "stocks", argh)
          request.send_request
        end

        it do
          request.outputs.length.should == 1
          request.outputs.first["result"].should == [
            {'name'=>'右ドアミラーB(8)',   'cd'=>10000005},
            {'name'=>'左ヘッドランプC(0)', 'cd'=>10000003}
          ]
        end
      end

      context "在庫数がゼロのものがある場合" do
        it '車両部品関連マスタに指定した部品CDのレコードが存在しない'
      end

      context "在庫数がすべてゼロ以上" do

        let(:argh){ {"car_cd" => "1002", "category_cd" => "8"} }

        before do
          request.execute("CarParts", "stocks", argh)
          request.send_request
        end

        it do
          request.outputs.length.should == 1
          request.outputs.first["result"].should == [
            {'name'=>'スピーカーB(12)', 'cd'=>80000002},
            {'name'=>'A/CアンプB(53)',  'cd'=>80000005}
          ]
        end
      end

    end

  end
end

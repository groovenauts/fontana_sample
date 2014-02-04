# -*- coding: utf-8 -*-
require File.expand_path('../spec_scripts_helper', __FILE__)

describe "CarParts" do # ストアドスクリプトモジュール名

  # ログイン
  let(:network){ new_network("1000007").tap{|n| n.login.should == true } }
  let(:request){ network.new_action_request }

  # fixtureのロード
  fixtures "car_parts"

  describe :stocks do # stocksアクションに対するテスト

    context "引数なし" do # テストケース1
      let(:argh){}

      before do
        err_msg = "1016: ストアドスクリプトCarParts.stocksの引数 car_cd が指定されていません"
        request.execute("CarParts", "stocks", argh)
        request.send_request
      end

      it do
        request.outputs.length.should == 1
        request.outputs.first["error"].nil?.should               == false
        request.outputs.first["error"]["message"].should         == err_msg
        request.outputs.first["error"]["input"]["id"].should     == 1
        request.outputs.first["error"]["input"]["action"].should == "execute"
        request.outputs.first["error"]["input"]["name"].should   == "CarParts"
        request.outputs.first["error"]["input"]["key"].should    == "stocks"
        request.outputs.first["result"].nil?.should              == true
      end
    end

    context "該当部品なし" do # テストケース2
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

    context "該当部品あり" do # テストケース3
      context "在庫数がゼロのものがある場合" do # テストケース3-1
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

      context "在庫数がゼロのものがある場合" do # テストケース3-2
        it '車両部品関連マスタに指定した部品CDのレコードが存在しない'
      end

      context "在庫数がすべてゼロ以上" do # テストケース3-3

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

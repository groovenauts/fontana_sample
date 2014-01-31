# -*- coding:utf-8 -*-

require 'libgss'
require 'pp'

def write_stdout(msg, r)
  result = r.outputs.get(1)["result"]
  puts msg
  pp result
  puts "---"*20
end

# ログイン
n = Libgss::Network.new("http://localhost:4000", device_type_cd: 1, client_version: "develop")
n.load_app_garden
n.login!

# アクションの実行
## 1
r = n.new_action_request
r.all("Maker")
r.send_request
write_stdout("【メーカー一覧を取得】", r)

## 2
r = n.new_action_request
r.all("Car", "maker_cd" => 1)
r.send_request
write_stdout("【選択したメーカー（トヨタ）の車名の一覧を取得】", r)

## 3
r = n.new_action_request
r.all("Car", "name" => "カローラ")
r.send_request
write_stdout("【選択した車名（カローラ）の型式一覧を取得】", r)

## 4
r = n.new_action_request
r.all("Car", "name" => "カローラ", "model" => "E-AE101G")
r.send_request
write_stdout("【選択した型式（E-AE101G）のタイプ一覧を取得】", r)

## 5
r = n.new_action_request
r.first("Car", "name" => "カローラ", "model" => "E-AE101G", "type" => "ステーションワゴン")
r.send_request
write_stdout("【選択したタイプ（ステーションワゴン）の車両情報を取得】", r)

### 車CDを変数に格納
car_cd = r.outputs.get(1)["result"]["cd"]

## 6
r = n.new_action_request
r.all("Category")
r.send_request
write_stdout("【部品カテゴリ一覧を取得】", r)

## 7
r = n.new_action_request
r.execute("CarParts", "stocks", {"car_cd" => car_cd, "category_cd" => 1})
r.send_request
write_stdout("【選択した部品カテゴリ（車検時関連品）の部品一覧と在庫数を取得】", r)

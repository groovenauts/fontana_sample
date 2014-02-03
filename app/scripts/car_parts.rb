# -*- coding: utf-8 -*-
require 'net/http'

module CarParts

  def stocks(argh)
    # 引数を変数に展開
    car_cd      = argh[:car_cd]
    category_cd = argh[:category_cd]

    # 取得結果格納用領域（配列）を準備
    result = []

    if car_cd && category_cd # 引数が指定されている場合のみ
      # CarPartコレクションから車CDと部品カテゴリを指定して、部品を取得
      parts = all(
                  name: 'CarPart',
                  conditions: {
                    'car_cd'           => car_cd,
                    'part_category_cd' => category_cd }
                  )

      result = parts.map do |p|
        # Stockコレクションから部品CDを指定して、部品在庫を取得。取得後に在庫数を足し込む
        c = all(name: 'Stock', conditions: {"part_cd" => p['part_cd']}).inject(0){|sum,i| sum + i[:num]}

        # Partコレクションから部品CDを指定して、部品在庫を取得。取得後に部品名のみを抽出
        n = first(name: 'Part' , conditions: {'cd' => p['part_cd']}, fields: [:name])[:name]

        {'name'=>"#{n}(#{c})", 'cd'=>p['part_cd']} # 結果をresultにつめる
      end
    end

    result # メソッドの戻り値
  end
end

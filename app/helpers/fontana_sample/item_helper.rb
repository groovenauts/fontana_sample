# -*- coding: utf-8 -*-
module FontanaSample
  module ItemHelper
    ITEM_LOG_NAMES = {
       1 => "ItemIncomingLog",
      -1 => "ItemOutgoingLog",
    }.freeze

    # 引数arghの:itemの中身をゲームデータのcontentに取得あるいは消費します。
    # その際、取得ログあるいは消費ログにアイテムコード毎に内容を記録します。
    # @param [Hash] argh ストアドスクリプトに渡された引数
    # @param [Fixnum] k  アイテムを取得の場合は1、消費する場合は-1
    # @return [String] "OK"
    def in_or_out(argh, k)
      log_name = ITEM_LOG_NAMES[k] or raise ArgumentError, "Invalid k: #{k} must be 1 or -1"

      item_hash = to_item_hash( source: argh[:item] )
      content = game_data["content"]

      items = content["items"] ||= {}
      item_hash.each do |item_code, amount|
        items[item_code.to_s] ||= 0
        items[item_code.to_s] += (amount * k)
        create(name: log_name, attrs: { "player_id" => player.player_id, "created_at" => server_time, "level" => player.level, "item_cd" => item_code, "outgoing_route_cd" => argh[:route_cd], "amount" => amount })
      end

      "OK"
    end
  end
end

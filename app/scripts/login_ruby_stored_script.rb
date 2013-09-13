# -*- coding: utf-8 -*-

require 'net/http'

module LoginRubyStoredScript

  def login_hook(argh)
    # GameDataにplayer_id以外の必須フィールドが設定されている場合、
    # 事前にGameDataを作成することができないため、ログインフックの中で作成する必要がある。
    return false unless player

    pf_player_info = (player.pf_player_info || {}).with_indifferent_access
    attrs = { gender: (pf_player_info[:gender] || 0), }
    if game_data.blank?
      create(name: 'GameData', attrs: attrs)
    else
      update(name: 'GameData', attrs: attrs)
    end
    return true
  end
end


result = {}
GameData.all.each do |gd|
  gd.content["items"].each do |item_code, item_count|
    hash = result[item_code] ||= {}
    hash[item_count] ||= 0
    hash[item_count] += 1
  end
end

Rails.logger.info("player_count per item and its count:\n" << result.to_yaml)

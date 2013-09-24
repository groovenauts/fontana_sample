def new_network(player_id = nil, url = "http://localhost:4000", options = {})
  options = {device_type_cd: 1, client_version: "2013073101"}.merge(options)
  network = Libgss::Network.new(url, options)
  network.player_id = player_id
  network.consumer_secret = AppGarden.config["consumer_secret"]
  network
end

def new_network(player_id = nil, url = "http://localhost:4000", options = {})
  options = {device_type_cd: 1, client_version: "develop"}.merge(options)
#  options = {device_type_cd: 1, client_version: "2013073101"}.merge(options)
  network = Libgss::Network.new(url, options)
  network.load_app_garden(File.expand_path("../../../../config/app_garden.yml", __FILE__))
  network.player_id = player_id
  network
end

class_name Server extends Node

var PORT := 34350
var MAX_CLIENTS := 10

func _ready() -> void:
	pass

func start_server(port : int = self.PORT, max_clients : int = self.MAX_CLIENTS) -> void:
	push_warning("called start_server")
	
	self.PORT = port
	self.MAX_CLIENTS = max_clients
	
	var peer = ENetMultiplayerPeer.new()
	
	peer.create_server(self.PORT, self.MAX_CLIENTS)
	
	multiplayer.multiplayer_peer = peer
	
	push_warning("peer id for this sesion is: ", peer.get_unique_id())

func kill_server() -> void:
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()

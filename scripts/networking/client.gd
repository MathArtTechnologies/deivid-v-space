class_name Client extends Node

var player_scene : PackedScene

@onready var players_manager : PlayersManager = $"../Players"

func _ready() -> void:
	self.player_scene = preload("res://scenes/characters/Spaceship.tscn")

func connect_to_server(host : String, port : int) -> void:
	push_warning("called connect_to_server")
	
	var peer := ENetMultiplayerPeer.new()
	
	peer.create_client(host, port)
	
	multiplayer.multiplayer_peer = peer
	
	push_warning("system peer_id is: ", multiplayer.get_unique_id())

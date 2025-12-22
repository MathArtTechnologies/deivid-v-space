class_name Game extends Node3D

@onready var ui = $UI
@onready var ui_pause = $UIPause
@onready var host_button : Button = $UI/VBoxContainer/ButtonHost
@onready var join_button : Button = $UI/VBoxContainer/ButtonJoin

var address : String
var port : int
var max_clients : int
var peer : ENetMultiplayerPeer

func _ready() -> void:
	self.peer = ENetMultiplayerPeer.new()
	self.address = "localhost"
	self.port = 3435
	self.max_clients = 10
	
	self.host_button.pressed.connect(self._on_host_pressed)
	self.join_button.pressed.connect(self._on_join_pressed)
	
	multiplayer.peer_connected.connect(self._on_peer_connected)
	multiplayer.connected_to_server.connect(self._on_connected_to_server)

func _on_host_pressed() -> void:
	self.peer.create_server(self.port, self.max_clients)
	multiplayer.multiplayer_peer = self.peer
	self.ui.hide()
	self._spawn_player(1)

func _on_join_pressed() -> void:
	self.peer.create_client(self.address, self.port)
	multiplayer.multiplayer_peer = self.peer
	self.ui.hide()

func _on_peer_connected(peer_id: int) -> void:
	self._spawn_player(peer_id)

func _on_connected_to_server() -> void:
	self._spawn_player(multiplayer.get_unique_id())

func _spawn_player(peer_id: int) -> void:
	var scene = preload("res://scenes/characters/Spaceship.tscn")
	var player = scene.instantiate()
	
	player.set_multiplayer_authority(peer_id)
	player.name = str(peer_id)
	
	get_parent().add_child(player)

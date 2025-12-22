class_name Game 
extends Node3D

@onready var display : Display = $Display

var address : String = "localhost"
var port : int = 3435
var max_clients : int = 10
var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new()

func _ready() -> void:
	self.display.host_button.pressed.connect(self._on_host_pressed)
	self.display.join_button.pressed.connect(self._on_join_pressed)
	
	multiplayer.peer_connected.connect(self._on_peer_connected)
	multiplayer.connected_to_server.connect(self._on_connected_to_server)
	
	self.display.set_lobby_menu_visible(true)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		self.display.set_pause_menu_visible(not Constants.paused)

func _on_host_pressed() -> void:
	self.peer.create_server(self.port, self.max_clients)
	multiplayer.multiplayer_peer = self.peer
	self._spawn_player(1)
	self.display.set_lobby_menu_visible(false)

func _on_join_pressed() -> void:
	self.peer.create_client(self.address, self.port)
	multiplayer.multiplayer_peer = self.peer
	self.display.set_lobby_menu_visible(false)

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

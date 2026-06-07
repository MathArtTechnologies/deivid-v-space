class_name Game 
extends Node3D

@onready var display : Display = $Display
@onready var player_manager : PlayerManager = $PlayerManager

var address : String = "localhost"
var port : int = 3435
var max_clients : int = 10
var peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new()

func _ready() -> void:
	self.display.host_button.pressed.connect(self._on_host_pressed)
	self.display.join_button.pressed.connect(self._on_join_pressed)
	
	multiplayer.peer_connected.connect(self._on_peer_connected)
	multiplayer.connected_to_server.connect(self._on_connected_to_server)
	multiplayer.connection_failed.connect(self._on_connection_failed)
	multiplayer.server_disconnected.connect(self._on_server_disconnected)
	multiplayer.peer_disconnected.connect(self._on_peer_disconnected)
	
	self.display.set_state(Display.DisplayState.LOBBY)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if self.display.state == Display.DisplayState.PAUSED:
			self.display.set_state(Display.DisplayState.INGAME)
		elif self.display.state == Display.DisplayState.INGAME:
			self.display.set_state(Display.DisplayState.PAUSED)

func _on_host_pressed() -> void:
	self.peer.create_server(self.port, self.max_clients)
	multiplayer.multiplayer_peer = self.peer
	self.player_manager.spawn_player(1)
	self.display.set_state(Display.DisplayState.INGAME)
	self.display.set_game_info(len(multiplayer.get_peers()) + 1)

func _on_join_pressed() -> void:
	self.address = self.display.get_host_ip()
	
	print("address: ", self.address)
	
	var error = self.peer.create_client(self.address, self.port)
	
	if error != 0:
		print("error when creating client: %d" % error)
	
	multiplayer.multiplayer_peer = self.peer
	
	self.display.set_state(Display.DisplayState.CONNECTING)

func _on_peer_connected(peer_id: int) -> void:
	self.player_manager.spawn_player(peer_id)
	self.display.set_game_info(len(multiplayer.get_peers()) + 1)

func _on_connected_to_server() -> void:
	self.player_manager.spawn_player(multiplayer.get_unique_id())
	self.display.set_state(Display.DisplayState.INGAME)
	self.display.set_client_info(multiplayer.get_unique_id(), self.address, self.port)

func _on_connection_failed() -> void:
	self.display.set_state(Display.DisplayState.LOBBY)

func _on_server_disconnected() -> void:
	self.display.set_state(Display.DisplayState.DISCONNECTED)

func _on_peer_disconnected(id : int) -> void:
	self.display.set_game_info(len(multiplayer.get_peers()) + 1)
	self.player_manager.sync_despawn.rpc(id)

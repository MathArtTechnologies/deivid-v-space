class_name PlayerManager extends Node

@onready var display : Display = $"../Display"

var players : Array = []

func _ready():
	self.display.on_respawn_click.connect(self._on_re_spawn_click)

func spawn_player(peer_id: int, position: Vector3) -> Spaceship:
	var scene = preload("res://scenes/characters/Spaceship.tscn")
	var player = scene.instantiate()
	
	player.set_multiplayer_authority(peer_id)
	player.name = str(peer_id)
	player.peer_id = peer_id
	
	add_child(player)
	
	players.push_back(player)
	
	if player.is_node_ready() == false:
		await player.ready
	
	var handler_on_die = func():
		self._on_player_die(player) 
	
	player.health_component.on_die.connect(handler_on_die)
	player.health_component.restore_health()
	
	self.display.set_game_info(len(self.players))
	self.display.set_state(Display.DisplayState.INGAME)
	return player

func despawn_player(peer_id: int) -> void:
	var player = null
	
	for i in self.players.size():
		player = self.players[i]
		
		if player.peer_id == peer_id:
			player.queue_free()
			self.players.remove_at(i)
			break

# when a player dies...

func _on_player_die(player):
	self.request_despawn_player(player.peer_id)

@rpc("any_peer", "call_local", "reliable")
func request_despawn_player(peer_id: int):
	
	if not multiplayer.is_server():
		self.request_despawn_player.rpc_id(1, peer_id)
		return
	
	self.handle_request_despawn_player.rpc(peer_id)

@rpc("authority", "call_local")
func handle_request_despawn_player(peer_id: int):
	self.despawn_player(peer_id)

# when a player re-spawns

func _on_re_spawn_click(peer_id) -> void:
	if !is_multiplayer_authority():
		return
	
	self.spawn_player(peer_id, Vector3.ZERO)


@rpc("any_peer", "call_local", "reliable")
func request_respawn(peer_id: int):
	if not multiplayer.is_server():
		return
	
	self.spawn_player(peer_id, Vector3.ZERO)

class_name PlayerManager extends Node

@onready var display : Display = $"../Display"

func _ready():
	set_multiplayer_authority(1)
	
	self.display.b_respawn.pressed.connect(on_respawn_pressed)

func spawn_player(id: int):
	print("spawn_player called, peer_id: %d" % id)
	
	var player = preload("res://scenes/characters/Spaceship.tscn").instantiate()
	
	player.name = str(id)
	player.set_multiplayer_authority(id)
	
	add_child(player)
	
	if player.is_node_ready() == false:
		await player.ready
	
	player.health_component.on_die.connect(func():
		self.sync_despawn.rpc(id)
	)
	
	player.team = randi()
	
	if multiplayer.get_unique_id() == id:
		self.display.bind_hud_events(player)
	
	return player

@rpc("any_peer", "call_local", "reliable")
func sync_spawn(id: int):
	self.spawn_player(id)

func despawn_player(id: int) -> void:
	print("spawn_player called, peer_id: %d" % id)
	
	for c in get_children():
		if c.name == str(id):
			c.queue_free()

@rpc("any_peer", "call_local", "reliable")
func sync_despawn(id : int):
	self.despawn_player(id)

func on_respawn_pressed():
	self.sync_spawn.rpc(multiplayer.get_unique_id())
	self.display.set_state(Display.DisplayState.INGAME)

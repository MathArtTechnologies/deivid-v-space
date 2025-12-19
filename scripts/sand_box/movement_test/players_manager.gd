class_name PlayersManager
extends Node

signal spawned_character(peer_id : int)
signal despawned_character(peer_id : int)

var player_scene = preload("res://scenes/characters/Spaceship.tscn")

func _ready():
	multiplayer.peer_connected.connect(self._on_peer_connected)

func _on_peer_connected(peer_id : int):
	push_warning("called _on_peer_connected, peer_id: ", peer_id, " system peer_id: ", multiplayer.get_unique_id())
	self._add_player_character(peer_id)

func _add_player_character(peer_id : int):
	var player_character : Spaceship = self.player_scene.instantiate()
	
	if peer_id == 1:
		return
	
	player_character.name = str(peer_id)
	player_character.set_multiplayer_authority(peer_id)
	#else:
		#player_character.name = str()
		#player_character.set_multiplayer_authority(multiplayer.get_unique_id())
	
	self.add_child(player_character)
	
	if player_character.is_multiplayer_authority():
		player_character.camera.current = true
	
	self.spawned_character.emit(peer_id)


func _on_multiplayer_spawner_spawned(node: Node) -> void:
	node.set_multiplayer_authority(multiplayer.get_unique_id())
	
	if node is Spaceship:
		node.camera.current = true

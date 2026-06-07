class_name HealthComponent extends Node

var max_health = 100: get = get_max_health, set = set_max_health
var health = 100: get = get_health, set = set_health

signal on_die
signal on_health_changed(new_value : int)
signal on_max_health_changed(new_value : int)

func _ready() -> void:
	# health is always dictated by the server, the one and only source of truth ~ wissens
	set_multiplayer_authority(1)

func set_max_health(value : int) -> void:
	max_health = value
	on_max_health_changed.emit(max_health)
	health = health

func get_max_health() -> int:
	return max_health

func set_health(value : int) -> void:
	health = clamp(value, 0, max_health)
	on_health_changed.emit(health)
	
	if health == 0:
		on_die.emit()

func get_health() -> int:
	return health

func _get_class_name() -> StringName:
	return "HealthComponent"

func take_damage(damage : int) -> void:
	health = health - damage

@rpc("any_peer", "reliable")
func request_take_damage(damage : int) -> void:
	if not multiplayer.is_server():
		request_take_damage.rpc_id(1, damage)
		return
	
	apply_take_damage.rpc(damage)

@rpc("authority", "call_local", "reliable")
func apply_take_damage(damage : int) -> void:
	take_damage(damage)

func restore_health():
	self.health = self.max_health

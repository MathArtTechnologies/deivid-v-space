class_name HealthComponent extends Node

var max_health = 100: get = get_max_health, set = set_max_health
var health = 100: get = get_health, set = set_health

signal on_die
signal on_health_changed(new_value : int)
signal on_max_health_changed(new_value : int)

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

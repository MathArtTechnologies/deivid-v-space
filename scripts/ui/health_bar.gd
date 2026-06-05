extends Node3D
class_name HealthBar

@onready var progress_bar : ProgressBar = $SubViewport/ProgressBar

var max_health: int = 100: set = set_max_health, get = get_max_health
var health: int = 100: set = set_health, get = get_health

func set_max_health(value : int) -> void:
	max_health = value
	progress_bar.max_value = value
	progress_bar.min_value = 0

func get_max_health() -> int:
	return max_health

func set_health(value : int) -> void:
	health = clamp(value, 0, max_health)
	progress_bar.value = health

func get_health() -> int:
	return health

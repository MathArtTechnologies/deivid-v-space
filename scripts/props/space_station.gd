class_name Spacestation extends RigidBody3D

@export var rotation_speed : float = 1

@onready var health_bar = $HealthBar
@onready var health_component = $HealthComponent

func _ready() -> void:
	health_component.on_health_changed.connect(_handle_on_health_change)
	health_component.on_max_health_changed.connect(_handle_on_max_health_changed)
	
	health_component.max_health = 1000
	health_component.health = health_component.max_health
	pass

func _process(delta: float) -> void:
	self.rotate(self.basis.y, rotation_speed * delta / 10)

func _handle_on_health_change(new_value) -> void:
	health_bar.health = new_value

func _handle_on_max_health_changed(new_value) -> void:
	health_bar.max_health = new_value

extends Node3D


@export var bala_tipo : shoot_type
@export var direccion : Vector3
var rapidez = bala_tipo.Velocidad


func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	if rapidez >= 0:
		position += rapidez*delta*direccion

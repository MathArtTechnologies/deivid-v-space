extends Node3D

var laser_es = load("res://laser_mesh.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		var laser = laser_es.instantiate()
		laser.position = global_position
		laser.transform.basis = get_parent().transform.basis
		laser.scale = Vector3(0.01,0.01,0.01)
		get_parent().get_parent().add_child(laser)

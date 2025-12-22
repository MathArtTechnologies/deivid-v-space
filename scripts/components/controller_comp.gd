class_name ControllerComp extends Node

var entity : Node3D
var camera : Camera3D

var viewport : Viewport

func _ready() -> void:
	self.viewport = get_viewport()

func get_move_direction() -> Vector3:
	var direction = 0
	
	if Input.is_action_pressed("forward"):
		direction += 1
	if Input.is_action_pressed("backward"):
		direction -= 1
	
	direction = direction * entity.basis.y
	
	return direction

func get_rotation() -> Vector3:
	var rotation := Vector3(0, 0, 0)
	var mouse_pos := get_viewport().get_mouse_position()
	var center : Vector2 = self.viewport.size / 2
	
	rotation.y = 0
	rotation.x = center.y - mouse_pos.y
	rotation.z = center.x - mouse_pos.x
	
	return rotation.normalized()

func _physics_process(_delta: float) -> void:
	if not is_multiplayer_authority():
		return
	
	if Constants.paused == true:
		return
	
	var mouse_pos := self.viewport.get_mouse_position()
	# print("viewport size: ", self.viewport.size)
	var sceen_center := Vector2(self.viewport.size.x / 2, self.viewport.size.y / 2)
	
	# var dir = sceen_center - mouse_pos
	
	# var target_pos = mouse_pos + (dir * delta) 
	
	Input.warp_mouse(sceen_center)

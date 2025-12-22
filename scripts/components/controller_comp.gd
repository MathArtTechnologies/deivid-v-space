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
	
	# consider mouse
	var mouse_pos := get_viewport().get_mouse_position()
	var center : Vector2 = self.viewport.size / 2
	
	rotation.x = center.y - mouse_pos.y
	rotation.z = center.x - mouse_pos.x
	
	# consider joystick
	var joystick_dir : Vector2 = Input.get_vector("left", "right", "up", "down")
	
	rotation.x = joystick_dir.y * -1
	rotation.z = joystick_dir.x * -1
	
	if Input.is_action_pressed("left_tilt"):
		rotation.y -= 1
	if Input.is_action_pressed("right_tilt"):
		rotation.y += 1
	
	return rotation.normalized()

func _physics_process(_delta: float) -> void:
	if not is_multiplayer_authority():
		return
	
	if Constants.paused == true:
		return
	
	# var mouse_pos := self.viewport.get_mouse_position()
	var sceen_center := Vector2(self.viewport.size.x / 2, self.viewport.size.y / 2)
	
	Input.warp_mouse(sceen_center)

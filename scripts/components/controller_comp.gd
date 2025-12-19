class_name ControllerComp extends Node

var entity : Node3D
var camera : Camera3D

var viewport : Viewport

var do_reposition_mouse : bool = true

signal pause()

func _ready() -> void:
	self.viewport = get_viewport()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		self.pause.emit()

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

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return
	
	if self.do_reposition_mouse == false:
		return
	
	var mouse_pos := self.viewport.get_mouse_position()
	# print("viewport size: ", self.viewport.size)
	var sceen_center := Vector2(self.viewport.size.x / 2, self.viewport.size.y / 2)
	
	# var dir = sceen_center - mouse_pos
	
	# var target_pos = mouse_pos + (dir * delta) 
	
	Input.warp_mouse(sceen_center)

class_name CharacterControllerComp extends Node

var entity : Node3D
var camera : Camera3D
var viewport : Viewport
var mouse_return_speed : float
var stabilize : bool

func _ready() -> void:
	if not is_multiplayer_authority():
		return
	
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	
	self.mouse_return_speed = 200
	self.viewport = get_viewport()
	self.stabilize = false

func get_move_direction() -> Vector3:
	var direction = 0
	
	if Input.is_action_pressed("thrust"):
		direction += 1
	
	direction = direction * entity.basis.y
	
	return direction

func get_rotation() -> Vector3:
	var rotation := Vector3(0, 0, 0)
	
	# consider mouse
	var mouse_pos := get_viewport().get_mouse_position()
	var center : Vector2 = get_viewport().size / 2
	
	rotation.x = int(clamp(center.y - mouse_pos.y, -1, 1))
	rotation.z = int(clamp(center.x - mouse_pos.x, -1, 1))
	
	# consider joystick
	var joystick_dir : Vector2 = Input.get_vector("yaw_left", "yaw_right", "pitch_up", "pitch_down")
	
	rotation.x += joystick_dir.y * -1
	rotation.z += joystick_dir.x * -1
	
	if Input.is_action_pressed("roll_left"):
		rotation.y -= 1
	if Input.is_action_pressed("roll_right"):
		rotation.y += 1
	
	return rotation.normalized()

func _process(_delta: float) -> void:
	if not is_multiplayer_authority():
		return
	
	if Constants.paused == true:
		return
	
	self.viewport = get_viewport()
	
	if Utils.HasComponent(self.entity, "CharacterRotationComp"):
		
		var sensitivity = 5
		
		var screen_siz = self.viewport.size
		var screen_cen = Vector2(screen_siz / 2)
		var cursor_pos = self.viewport.get_mouse_position()
		var cursor_foc = cursor_pos - screen_cen
		var cursor_toc = screen_cen - cursor_pos 
		
		#print("cursor_position:    ", cursor_pos)
		#print("screen_size:        ", screen_siz)
		#print("cursor_from_center: ", cursor_foc)
		#print("cursor_to_center:   ", cursor_toc)
		
		var step = cursor_toc * _delta * sensitivity
		
		# work the floating points, snapping to the center prevents locking in continuous rotation
		
		if cursor_toc.x != 0.0:
			step.x = sign(cursor_toc.x) * max(abs(step.x), 1.0)
		if cursor_toc.y != 0.0:
			step.y = sign(cursor_toc.y) * max(abs(step.y), 1.0)
		
		if cursor_toc.length() < 0.5:
			self.viewport.warp_mouse(screen_cen)
		else:
			self.viewport.warp_mouse(cursor_pos + step)
		
		# yaw... ing
		
		var ca_x = (screen_siz.x / 2) / tan(deg_to_rad(self.camera.fov / 2))
		var yaw_angle = atan(step.x / ca_x) 
		self.entity.rotate(self.entity.basis.z.normalized(), yaw_angle)
		
		# pitch... ing
		
		var ca_y = (screen_siz.y / 2) / tan(deg_to_rad(self.camera.fov / 2))
		var pitch_angle = atan(step.y / ca_y)
		self.entity.rotate(self.entity.basis.x.normalized(), pitch_angle)
		
		# roll... ing
		
		var roll_speed = 3
		
		if Input.is_action_pressed("roll_left"):
			self.entity.rotate(self.entity.basis.y, -1 * _delta * roll_speed)
		if Input.is_action_pressed("roll_right"):
			self.entity.rotate(self.entity.basis.y, 1 * _delta * roll_speed)
		
		if Input.is_action_just_pressed("toggle"):
			self.stabilize = !self.stabilize
		
		# un-roll... ing ("estabilizar" esta wea)
		
		if self.stabilize:
			if not Input.is_action_pressed("roll_left") and not Input.is_action_pressed("roll_right"):
				var forward = self.entity.basis.y
				var target_up = (Vector3.UP - Vector3.UP.dot(forward) * forward).normalized()
				if target_up.length_squared() > 0.001:
					var roll_error = self.entity.basis.z.signed_angle_to(target_up, forward)
					self.entity.rotate(forward.normalized(), roll_error * _delta * roll_speed)

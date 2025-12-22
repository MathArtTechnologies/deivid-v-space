extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		self.set_pause(not Constants.paused)

func set_pause(active : bool) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if active else Input.MOUSE_MODE_CAPTURED
	self.visible = active
	Constants.paused = active

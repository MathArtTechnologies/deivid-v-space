class_name Spaceship extends CharacterBody3D

var character_velocity_comp : CharacterVelocityComp
var controller_comp : ControllerComp
var character_rotation_component : CharacterRotationComp

var camera : Camera3D

func _ready() -> void:
	self.character_velocity_comp = $CharacterVelocityComp
	self.character_velocity_comp.direction = Vector3(0, 0, 0)
	self.character_velocity_comp.speed = 20
	self.character_velocity_comp.entity = self
	
	self.character_rotation_component = $CharacterRotationComp
	self.character_rotation_component.rotation = Vector3(0, 0, 0)
	self.character_rotation_component.speed = 2
	self.character_rotation_component.entity = self
	
	self.camera = $Camera
	
	self.controller_comp = $ControllerComp
	self.controller_comp.camera = self.camera
	self.controller_comp.entity = self

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_text_backspace"):
		self.position = Vector3(4, 4, 4)

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return
	
	push_warning("system player pos: ", self.position)
	
	self.character_velocity_comp.direction = self.controller_comp.get_move_direction()
	self.character_rotation_component.rotation = self.controller_comp.get_rotation()
	
	move_and_slide()

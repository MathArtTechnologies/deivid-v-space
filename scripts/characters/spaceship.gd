class_name Spaceship extends CharacterBody3D

var character_velocity_comp : CharacterVelocityComp
var controller_comp : CharacterControllerComp
var character_rotation_component : CharacterRotationComp

var camera : Camera3D

var rotation_speed : float = 20.0
var movement_speed : float = 1.5

func _ready() -> void:
	self.character_velocity_comp = $CharacterVelocityComp
	self.character_velocity_comp.direction = Vector3(0, 0, 0)
	self.character_velocity_comp.speed = self.movement_speed
	self.character_velocity_comp.entity = self
	
	self.character_rotation_component = $CharacterRotationComp
	self.character_rotation_component.rotation = Vector3(0, 0, 0)
	self.character_rotation_component.speed = self.rotation_speed
	self.character_rotation_component.entity = self
	
	self.camera = $Camera
	
	self.controller_comp = $CharacterControllerComp
	self.controller_comp.camera = self.camera
	self.controller_comp.entity = self
	
	if is_multiplayer_authority():
		self.camera.current = true

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority():
		return

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return
	
	if Constants.paused == true:
		return
	
	self.character_velocity_comp.direction = self.controller_comp.get_move_direction()
	self.character_rotation_component.rotation = self.controller_comp.get_rotation()

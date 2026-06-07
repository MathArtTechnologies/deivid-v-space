class_name Spaceship extends CharacterBody3D

var peer_id : int

var character_velocity_comp : CharacterVelocityComp
var controller_comp : CharacterControllerComp
var character_rotation_component : CharacterRotationComp
var health_component : HealthComponent

var camera : Camera3D
var health_bar : HealthBar

var rotation_speed : float = 1.5
var movement_speed : float = 20

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
	self.health_bar = $HealthBar
	
	self.controller_comp = $CharacterControllerComp
	self.controller_comp.camera = self.camera
	self.controller_comp.entity = self
	
	self.health_component = $HealthComponent
	self.health_component.on_health_changed.connect(_on_health_changed)
	self.health_component.on_max_health_changed.connect(_on_max_health_changed)
	
	self.health_component.max_health = 100 
	self.health_component.health = self.health_component.max_health
	
	if is_multiplayer_authority():
		self.camera.current = true
		self.health_bar.visible = false
		$GPUParticles3D.visible = true

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority():
		return

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return
	
	if GlobalsRepo.paused == true:
		return
	
	var move_dir := self.controller_comp.get_move_direction()
	var rotation := self.controller_comp.get_rotation()
	
	_set_engine_is_trusting(move_dir != Vector3.ZERO or rotation != Vector3.ZERO)
	
	if (Input.is_action_pressed("boost")):
		self.character_velocity_comp.speed = self.movement_speed * 1.2
		#self.camera.position.y = -10
		self.camera.fov = 65
	else:
		self.character_velocity_comp.speed = self.movement_speed
		#self.camera.position.y = -8
		self.camera.fov = 60
	
	self.character_velocity_comp.direction = move_dir
	#self.character_rotation_component.rotation = rotation

func _set_engine_is_trusting(is_trusting: bool) -> void:
	var particles = $EngineParticles
	
	particles.emitting = is_trusting

func _on_health_changed(new_value):
	self.health_bar.health = new_value

func _on_max_health_changed(new_value):
	self.health_bar.max_health = new_value

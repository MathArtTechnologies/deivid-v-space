class_name CharacterVelocityComp
extends Node

var direction : Vector3
var speed : float
var entity : CharacterBody3D

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return
	
	self.entity.position += self.direction.normalized() * self.speed * delta
	self.entity.move_and_slide()

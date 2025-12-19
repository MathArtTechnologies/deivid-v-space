class_name CharacterRotationComp extends Node

var rotation : Vector3
var entity : CharacterBody3D
var speed : float

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return
	
	self.entity.rotate(self.entity.basis.x.normalized(), self.rotation.x * delta * speed)
	self.entity.rotate(self.entity.basis.y.normalized(), self.rotation.y * delta * speed)
	self.entity.rotate(self.entity.basis.z.normalized(), self.rotation.z * delta * speed)
	
	self.entity.move_and_slide()

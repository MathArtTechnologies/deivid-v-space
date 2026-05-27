extends RigidBody3D

@export var rotation_speed : float = 1

func _process(delta: float) -> void:
	self.rotate(self.basis.y, rotation_speed * delta / 10)

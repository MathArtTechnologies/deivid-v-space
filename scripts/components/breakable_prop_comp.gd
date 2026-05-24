class_name BreakablePropComp extends Node

var entity : Node3D
var parts := []
var free_on_break := true
var force := 1.0

func do_break() -> void:
	for p : RigidBody3D in parts:  
		p.apply_impulse(p.get_child(0).position * self.force, self.entity.global_position)
	
	if free_on_break:
		await get_tree().create_timer(5).timeout;
		self.entity.queue_free()

func _get_class_name() -> StringName:
	return "BreakablePropComp"

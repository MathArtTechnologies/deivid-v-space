class_name BreakablePropComp extends Node

var entity : Node3D
var parts := []
var free_on_break := true
var free_timeout := 5
var force := 1.0

var allready_broken := false

func do_break() -> void:
	if allready_broken:
		return
	allready_broken = true
	
	for p : RigidBody3D in parts:  
		p.apply_impulse(p.get_child(0).position * self.force, self.entity.global_position)
	
	if free_on_break:
		await get_tree().create_timer(free_timeout).timeout;
		self.entity.queue_free()

func _get_class_name() -> StringName:
	return "BreakablePropComp"

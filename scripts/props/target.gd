class_name Target 
extends Node3D

@export var autoDestory := false

var breakable_prop_comp : BreakablePropComp

func _ready() -> void:
	
	breakable_prop_comp = $BreakablePropComp
	breakable_prop_comp.free_on_break = true
	breakable_prop_comp.force = 1.2
	breakable_prop_comp.entity = self
	
	for c in self.get_children():
		if c is RigidBody3D:
			breakable_prop_comp.parts.append(c)
	
	if autoDestory:
		await get_tree().create_timer(2).timeout;
		breakable_prop_comp.do_break()

class_name weapon_handler
extends Node3D

@export var armas : weapon_menu
@onready var camara_jug = $"../Camera"

var ind_arma : int = 0
var objetivo : Dictionary
var interseccion : Vector3

@onready var sel_arma : shoot_type = armas.disparos[ind_arma]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		disparar()

func disparar() -> void:
	var space_state : PhysicsDirectSpaceState3D = camara_jug.get_world_3d().direct_space_state
	var ray_dir : Vector3 = -camara_jug.global_basis.z
	var ray_ini : Vector3 = camara_jug.global_position
	var ray_fin : Vector3 = ray_ini + (ray_dir.normalized() * sel_arma.Alcance )
	
	var rayo := PhysicsRayQueryParameters3D.create(ray_ini,ray_fin)
	rayo.collide_with_bodies = true
	objetivo = space_state.intersect_ray(rayo)
	if objetivo != {}:
		interseccion = objetivo["position"]
	print(ray_fin)
	print(objetivo)
	
	if len(objetivo) == 0:
		return
	
	# not sure if this is the right way to do this (probably not), please fix if needed ~ wissens
	var collider = objetivo['collider']
	
	if collider is RigidBody3D:
		if collider.get_parent() is Target:
			collider.get_parent().breakable_prop_comp.do_break()

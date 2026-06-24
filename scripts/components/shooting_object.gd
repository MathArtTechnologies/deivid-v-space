extends Node


@export var armas : weapon_menu
@export var id_arma : int = 0

@export var fuente : Vector3
@export var direccion : Vector3

var objetivo : Dictionary
var interseccion : Vector3
var padre : Node3D = get_parent()
var sel_arma : shoot_type = armas.disparos[id_arma]

func shoot_projectile(Bala:PackedScene,fuente:Vector3):
	var bala = Bala.instantiate()
	bala.global_position = fuente
	get_tree().root.add_child(bala)


func raytrace() -> void:
	if not is_multiplayer_authority():
		return
	
	var space_state : PhysicsDirectSpaceState3D = padre.get_world_3d().direct_space_state
	var ray_dir : Vector3 = -padre.global_basis.z
	var ray_ini : Vector3 = padre.global_position
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
	
	var collider = objetivo['collider']
	
	_handle_collisio(collider)


func _handle_collisio(collider) -> void:
	
	if collider is RigidBody3D:
		if collider.get_parent() is Target:
			#collider.get_parent().breakable_prop_comp.do_break()
			collider.get_parent().breakable_prop_comp.request_break()
		
		return
	
	if collider is Spaceship:
		collider.health_component.request_take_damage(sel_arma.Daño)

func shoot_fr():
	if sel_arma.Velocidad < 0:
		raytrace()
	else:
		shoot_projectile(sel_arma.proyectil,padre.global_position)

func one_weapon() -> void:
	id_arma = 0

func sec_weapon() -> void:
	id_arma = 1

func _ready() -> void:
	SignalBus.disparo.connect(shoot_fr)
	SignalBus.arma1.connect(one_weapon)
	SignalBus.arma2.connect(sec_weapon)

extends Node3D

#@onready var armas = $player_shooting.armas
@onready var camara = $"../Camera"
var laser_es = load("res://scenes/components/laser.tscn")
var laser = laser_es.instantiate()
var disparando = false
var alcance = 100


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	laser.visible = false
	get_parent().get_parent().add_child(laser)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		var origen = global_position
		var dir = -camara.global_basis.z.normalized()
		var final = camara.global_position + (dir * alcance )
		dibujar_laser(origen,final)
	else:
		laser.visible = false
		
		
func dibujar_laser(desde: Vector3, hasta: Vector3):
	var largo = desde.distance_to(hasta)
	var centro = (desde + hasta) / 2.0
	var direccion = (hasta - desde).normalized()
	
	laser.global_position = centro
	laser.global_basis = Basis.looking_at(direccion, Vector3.UP)
	laser.rotate_object_local(Vector3.RIGHT, PI / 2.0)
	laser.mesh.height = largo
	laser.visible = true

extends Resource
class_name shoot_type

@export var Nombre : String

@export_group("Daño")
@export var Daño : int = 20

@export_group("Alcance")
@export var Alcance : int = 100

@export_group("Municion")
@export var Municion : int = 50

@export_group("Recarga")
@export var Tiempo : int = 2

@export_group("Frecuencia")
@export_range(0,50) var Frecuencia : float = 1

@export_group("Velocidad")
@export var Velocidad : int = 5

@export_group("Movimiento")
@export var Lineal : bool = true
@export var Dirigido : bool = false
@export var Random : bool = true

@export_group("Efectos")
@export var Desvanecer : bool = true
@export var Explosion : bool = false
@export var Split : bool = false
@export var Rebotar : bool = false

@export_group("Animacion")
@export var proyectil : PackedScene

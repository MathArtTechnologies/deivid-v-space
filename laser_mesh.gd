extends MeshInstance3D

@export var speed : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.basis * Vector3(0,speed,0) * delta
	
	


func _on_timer_timeout() -> void:
	queue_free()

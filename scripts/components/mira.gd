extends CenterContainer

@export var dot_size : float = 1
@export var dot_color : Color = Color.WHITE

func _draw() -> void:
	draw_circle(Vector2.ZERO,dot_size,dot_color)

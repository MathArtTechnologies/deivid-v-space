extends Node


func _process(_delta: float) -> void:
	if not is_multiplayer_authority():
		return
	if Input.is_action_pressed("shoot"):
		SignalBus.disparo.emit()
	if Input.is_action_pressed("number1"):
		SignalBus.arma1.emit()
	if Input.is_action_pressed("number2"):
		SignalBus.arma2.emit()

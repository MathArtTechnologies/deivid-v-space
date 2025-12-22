class_name Display extends Control

@onready var join_button : Button = $NetworkControls/VBoxContainer/Join
@onready var host_button : Button = $NetworkControls/VBoxContainer/Host
@onready var network_controls = $NetworkControls
@onready var fade : ColorRect = $Fade
@onready var info_label : Label = $ClientInfo

func _process(_delta: float) -> void:
	# update client info label
	if multiplayer.is_server() == false:
		self.info_label.text = "peer_id: %d" % multiplayer.get_unique_id()
	else:
		self.info_label.text = "peer_id: 1"

func set_lobby_menu_visible(visible_: bool) -> void:
	self.network_controls.visible = visible_
	self.fade.visible = visible_
	self._set_cursor_visible(visible_)

func set_pause_menu_visible(visible_: bool) -> void:
	self.fade.visible = visible_
	Constants.paused = visible_
	self._set_cursor_visible(visible_)

func _set_cursor_visible(visible_ : bool) -> void:
	if not visible_:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

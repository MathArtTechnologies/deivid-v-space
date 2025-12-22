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

func set_lobby_menu_visible(visible: bool) -> void:
	self.network_controls.visible = visible
	self.fade.visible = visible

func set_pause_menu_visible(visible: bool) -> void:
	self.fade.visible = visible
	Constants.paused = visible

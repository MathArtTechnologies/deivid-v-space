class_name Display extends Control

@onready var join_button : Button = $NetworkControls/VBoxContainer/Join
@onready var host_button : Button = $NetworkControls/VBoxContainer/Host
@onready var network_controls = $NetworkControls
@onready var fade : ColorRect = $Fade
@onready var info_label : Label = $ClientInfo
@onready var ip_edit : TextEdit = $NetworkControls/VBoxContainer/IP

func _process(_delta: float) -> void:
	pass

func set_lobby_menu_visible(visible_: bool) -> void:
	self.network_controls.visible = visible_
	self.fade.visible = visible_
	self._set_cursor_visible(visible_)

func set_pause_menu_visible(visible_: bool) -> void:
	self.fade.visible = visible_
	Constants.paused = visible_
	self._set_cursor_visible(visible_)

func _set_cursor_visible(visible_ : bool) -> void:
	#visible_ = true
	
	if not visible_:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func get_host_ip():
	var ip_str : String = ip_edit.text.strip_edges()
	
	if ip_str.is_valid_ip_address():
		return ip_str
	else:
		return "127.0.0.1"

func set_client_info(peer_id, host, port):
	self.info_label.text = ""
	
	self.info_label.text += "peer_id: %d" % peer_id
	self.info_label.text += "\nhost: %s" % host
	self.info_label.text += "\nport: %s" % port
	
	## update client info label
	#if multiplayer.is_server() == false:
		#self.info_label.text += "peer_id: %d" % multiplayer.get_unique_id()
	#else:
		#self.info_label.text += "peer_id: 1"

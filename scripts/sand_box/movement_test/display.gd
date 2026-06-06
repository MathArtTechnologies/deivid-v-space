class_name Display extends Control

enum DisplayState { LOBBY, CONNECTING, INGAME, PAUSED, DISCONNECTED }

var state : DisplayState

@onready var lobby : Control = $Lobby
@onready var connecting : Control = $Connecting
@onready var pause : Control = $Pause
@onready var hud : Control = $HUD
@onready var disconnected : Control = $Disconnected
@onready var join_button : Button = $Lobby/NetworkControls/VBoxContainer/Join
@onready var host_button : Button = $Lobby/NetworkControls/VBoxContainer/Host
@onready var network_controls = $Lobby/NetworkControls
@onready var info_label : Label = $ClientInfo
@onready var ip_edit : TextEdit = $Lobby/NetworkControls/VBoxContainer/IP
@onready var health_bar : ProgressBar = $HUD/HealthBar
@onready var health_label : Label = $HUD/HealthLabel

func _process(_delta: float) -> void:
	pass

func set_state(state : DisplayState) -> void:
	self.state = state
	
	self.lobby.visible = state == DisplayState.LOBBY
	self.connecting.visible = state == DisplayState.CONNECTING
	self.hud.visible = state == DisplayState.INGAME
	self.pause.visible = state == DisplayState.PAUSED
	self.disconnected.visible = state == DisplayState.DISCONNECTED
	
	Constants.paused = state == DisplayState.PAUSED || state == DisplayState.DISCONNECTED
	
	self._set_cursor_visible(state != DisplayState.INGAME)

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

func bind_hud_events(character : Spaceship) -> void:
	if not character.is_node_ready():
		await character.ready 
	
	character.health_component.on_health_changed.connect(_on_health_changed)
	character.health_component.on_max_health_changed.connect(_on_max_health_changed)
	
	self.health_bar.value = character.health_component.health
	self.health_bar.max_value = character.health_component.max_health
	self._update_health_label()

func _on_health_changed(new_value: int) -> void:
	self.health_bar.value = new_value
	self._update_health_label()

func _on_max_health_changed(new_value: int) -> void:
	self.health_bar.max_value = new_value
	self._update_health_label()

func _update_health_label() -> void:
	self.health_label.text = "Health: %d / %d" % [self.health_bar.value, self.health_bar.max_value]

func _on_back_to_lobby_pressed() -> void:
	print("_on_back_to_lobby_pressed called")
	self.set_state(Display.DisplayState.LOBBY)

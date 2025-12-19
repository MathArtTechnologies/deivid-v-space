class_name MovementTestUI extends Control

var server : Server
var client : Client
var controller_comp : ControllerComp

var ui_pause : Control
var host_edit : TextEdit
var port_edit : TextEdit

func _ready() -> void:
	self.visible = true
	self.client = $"../Client"
	self.server = $"../Server"
	
	self.ui_pause = $"../UIPause"
	
	self.controller_comp = $ControllerComp
	self.controller_comp.do_reposition_mouse = false
	self.controller_comp.pause.connect(self._on_pause)
	
	self.host_edit = $VBoxContainer/HBoxContainer/Host
	self.port_edit = $VBoxContainer/HBoxContainer2/Port

func _on_pause() -> void:
	var tree = get_tree() 
	
	if tree.paused:
		self.ui_pause.visible = false
		tree.paused = false
	else:
		self.ui_pause.visible = true
		tree.paused = true

func _on_button_join_pressed() -> void:
	push_warning("called _on_button_join_pressed")
	var host = self.host_edit.text.strip_edges()
	var port = int(self.port_edit.text.strip_edges())
	
	self.client.connect_to_server(host, port)
	
	self.visible = false


func _on_button_host_pressed() -> void:
	push_warning("called _on_button_host_pressed")
	var port = int(self.port_edit.text.strip_edges())
	
	self.server.start_server(port)
	
	self.visible = false

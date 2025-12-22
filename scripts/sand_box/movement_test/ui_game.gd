extends Control

@onready var l_peer_id : Label = $LPeerId
@onready var l_role : Label = $LRole

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	self.l_peer_id.text = "peer id: %d" % multiplayer.get_unique_id()
	self.l_role.text = "role: server" if multiplayer.is_server() else "role: client"

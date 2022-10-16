extends AudioStreamPlayer
var is_playing: bool = false

func _ready():
	connect("finished", 
		get_node("/root/PlayerWindow/PlayerLength_container"),
		 "_on_AudioStreamPlayer_finished")
	connect("finished", 
		get_node("/root/PlayerWindow/PlayerControl_Container"),
		 "_on_AudioStreamPlayer_finished")

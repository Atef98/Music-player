extends HBoxContainer

var stop_icon = load("res://Icons/g1141.png")
onready var btn_play = $Btn_play
onready var play_icon = btn_play.icon
onready var btn_loop = $Btn_loop

func _on_PlayerWindow_stream_state_change():
	if GlobalAudioStreamPlayer.is_playing:
		btn_play.icon = stop_icon
	else:
		btn_play.icon = play_icon


func _on_AudioStreamPlayer_finished():
	GlobalAudioStreamPlayer.is_playing = false
	btn_play.icon = play_icon


func _on_Btn_loop_toggled(button_pressed):
	if button_pressed:
		btn_loop.self_modulate = Color.dodgerblue
	else:
		btn_loop.self_modulate = Color.white

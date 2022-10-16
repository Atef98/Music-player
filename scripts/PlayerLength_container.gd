extends HBoxContainer
onready var player_slider: HSlider = $Player_slider
onready var current_time_lable: Label = $Current_time
onready var finish_time_lable: Label = $Finish_Time
onready var audio_stream_node: AudioStreamPlayer = GlobalAudioStreamPlayer
onready var timer: Timer = get_node("/root/PlayerWindow/Timer")
var stream_length: float = 0.0
var current_time: Dictionary = {}

func _on_PlayerWindow_stream_state_change():
	if audio_stream_node.is_playing and player_slider.value == 0:
		if stream_length != audio_stream_node.stream.get_length():
			stream_length = audio_stream_node.stream.get_length()
			var time = seconds2time(stream_length)
			player_slider.max_value = round(stream_length)
			finish_time_lable.text = "%0d:%02d" % [time.min , time.sec]
			player_slider.editable = true
		timer.start()
	elif player_slider.value > 0 and audio_stream_node.is_playing:
		audio_stream_node.stream_paused = false
		timer.start()
	else:
		timer.stop()


func _on_Timer_timeout():
	var playback_pos = (audio_stream_node.get_playback_position())
	current_time = seconds2time(playback_pos)
	player_slider.value = playback_pos
	if (current_time.sec == 60):
		current_time.min+=1
		current_time.sec = 0
	current_time_lable.text = "%0d:%02d" % [current_time.min, current_time.sec] 


func _on_Player_slider_value_changed(value):
	audio_stream_node.seek(value)


func _on_AudioStreamPlayer_finished():
	# create delay due the rounded values '4.67 = 5', as the stream finishes befor the slider
	yield(get_tree().create_timer(round(stream_length) - stream_length), "timeout")
	timer.stop()
	reset_player_time()
	player_slider.editable = false

func seconds2time(sec: float = 0) -> Dictionary:
	 return {"min": int(sec / 60), "sec":  round(fmod(sec, 60))}


func reset_player_time() -> void:
	audio_stream_node.seek(0.0)
	player_slider.value = 0
	current_time_lable.text = "%0d:%02d" % [0, 0]






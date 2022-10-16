extends Control
onready var popup: Popup = $Popup
onready var audio_stream_node: AudioStreamPlayer = GlobalAudioStreamPlayer
onready var fileDialog: FileDialog = $FileDialog
onready var track_name: Label = $PlayerName_container/Track_name

var file_path: String = ""
var navigate_file: NavigatFiles = NavigatFiles.new()
var first_time: bool = true
# emits when the stream plays
signal stream_state_change


func _on_Btn_play_pressed():
	if navigate_file.current_file == "":
		popup.popup()
		return
	elif audio_stream_node.is_playing:
		audio_stream_node.set_stream_paused(true)
		audio_stream_node.is_playing = false
	elif audio_stream_node.stream_paused == true:
		audio_stream_node.set_stream_paused(false)
		audio_stream_node.is_playing = true
	else:
		audio_stream_node.play()
		audio_stream_node.is_playing = true
	emit_signal("stream_state_change")

func _on_Btn_reload_pressed():
	if not audio_stream_node.is_playing and audio_stream_node.stream_paused:
		audio_stream_node.play(0.0)
		audio_stream_node.is_playing = true
		emit_signal("stream_state_change")# to start the timer
	elif audio_stream_node.is_playing:
		audio_stream_node.play(0.0)

func _on_Btn_prevuios_pressed():
	navigate_file.get_back()
	if not navigate_file.end_of_array:
		set_playback()

func _on_Btn_next_pressed():
	navigate_file.get_next()
	if not navigate_file.end_of_array:
		set_playback()


func _on_Btn_loop_pressed():
	if audio_stream_node.stream != null and audio_stream_node.is_playing:
		var playback_pos = audio_stream_node.get_playback_position()
		audio_stream_node.stream.loop = not audio_stream_node.stream.loop
		audio_stream_node.play(playback_pos)
	elif audio_stream_node.stream_paused:
		var playback_pos = audio_stream_node.get_playback_position()
		audio_stream_node.stream.loop = not audio_stream_node.stream.loop
		audio_stream_node.play(playback_pos)
		emit_signal("stream_state_change")

func _on_Btn_open_pressed():
	fileDialog.popup()


func _on_FileDialog_file_selected(path):
	file_path = path
	if first_time:
		get_tree().call_group("buttons", "set", "disabled", false)
		first_time = false
	navigate_file = NavigatFiles.new()
	navigate_file.get_files_in_dir(file_path, ".mp3")
	set_playback()


func generate_stream(path:String) -> AudioStream:
	var snd_file=File.new()
	snd_file.open(path, File.READ)
	var stream = AudioStreamMP3.new()
	stream.data = snd_file.get_buffer(snd_file.get_len())
	snd_file.close()
	return stream

func set_playback() -> void :
	track_name.arabic_input = navigate_file.current_file.get_file()
	audio_stream_node.stream = generate_stream(navigate_file.current_file)
	audio_stream_node.stream.loop = false
	if audio_stream_node.stream_paused:
		audio_stream_node.stream_paused = false
	audio_stream_node.play()
	audio_stream_node.is_playing = true
	$PlayerLength_container.reset_player_time()
	emit_signal("stream_state_change")





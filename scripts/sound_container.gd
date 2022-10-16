extends Control
onready var container = $"."
onready var btn_sound = $Sound_btn
onready var sound_slider = $Sound_slider
var sound_icon0 = load("res://Icons/g1188.png")
var sound_icon1 = load("res://Icons/g1165.png")
var sound_icon2 = load("res://Icons/g1172.png")
var sound_icon3 = load("res://Icons/g1181.png")


func _ready():
	sound_slider.value = 0.4

func _on_Sound_btn_pressed():
	if not sound_slider.visible:
		sound_slider.show()
	else:
		sound_slider.hide()

func _on_Sound_container_focus_exited():
	if sound_slider.visible:
		sound_slider.hide()

# handle sound&icon when value changed
func _on_Sound_slider_value_changed(value):
	set_sound(value)

func set_sound(value_ln: float = 0.4):
	GlobalAudioStreamPlayer.volume_db = linear2db(value_ln)
	value_ln = int(value_ln * 100)
	if value_ln == 0:
		btn_sound.icon = sound_icon0
	elif value_ln in range(1, 40):
		btn_sound.icon = sound_icon1
	elif value_ln in range(40, 85):
		btn_sound.icon = sound_icon2
	else:
		btn_sound.icon = sound_icon3


func _on_Sound_slider_drag_ended(_value_changed):
	sound_slider.hide()

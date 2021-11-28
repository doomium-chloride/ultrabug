extends Control


var next_scene = "res://Screens/Menu.tscn"
export var disabled = false

func goto_scene():
	Global.goto_scene(next_scene)


func _on_LinkButton_pressed():
	if disabled:
		return
	goto_scene()

func stop_audio():
	$AudioStreamPlayer.stop()

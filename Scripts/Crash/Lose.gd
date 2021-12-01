extends Control

func _ready():
	Global.emit_signal("pause_time", true)

func _on_Restart_pressed():
	if Global.last_level:
		Global.emit_signal("pause_time", false)
		Global.goto_scene(Global.last_level)
	else:
		_on_Quit_pressed()


func _on_Quit_pressed():
	Global.goto_scene("res://Screens/Menu.tscn")

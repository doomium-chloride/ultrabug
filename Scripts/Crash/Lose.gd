extends Control

func _on_QuitButton_pressed():
	Global.goto_scene("res://Screens/Menu.tscn")


func _on_Restart_pressed():
	if Global.last_level:
		Global.goto_scene(Global.last_level)
	else:
		_on_QuitButton_pressed()

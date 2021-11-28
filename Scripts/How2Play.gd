extends "res://Scripts/BaseMap.gd"


func _ready():
	walls_needed = 5
	chips_needed = 2
	next_scene = "res://Screens/crash/Basic.tscn"
	update_ui()
	Global.emit_signal("set_last_level", "res://Screens/How2Play.tscn")

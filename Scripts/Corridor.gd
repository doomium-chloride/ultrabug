extends "res://Scripts/BaseMap.gd"

func _ready():
	walls_needed = 50
	chips_needed = 3
	next_scene = "res://Screens/crash/Error2.tscn"
	update_ui()
	Global.emit_signal("set_last_level", "res://Maps/Corridor.tscn")

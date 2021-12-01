extends "res://Scripts/BaseMap.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	walls_needed = 80
	chips_needed = 1
	next_scene = "res://Screens/crash/Error1.tscn"
	update_ui()
	Global.emit_signal("set_last_level", "res://Maps/TestLevel.tscn")

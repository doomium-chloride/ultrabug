extends "res://Scripts/BaseMap.gd"

func _ready():
	walls_needed = 20
	chips_needed = 1
	next_scene = "res://Screens/Win.tscn"
	update_ui()
	Global.emit_signal("set_last_level", "res://Maps/Lshape.tscn")

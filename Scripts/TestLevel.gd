extends Node2D


var chips_needed = 1
var walls_needed = 20

var chips = 0
var walls = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.emit_signal("reset_chip", 1)
	Global.emit_signal("reset_wall_count", 20)
	Global.connect("add_chip", self, "add_chip")
	Global.connect("add_wall_count", self, "add_wall")

func check_victory():
	if chips >= chips_needed and walls >= walls_needed:
		Global.goto_scene("res://Screens/Win.tscn")

func add_chip():
	chips += 1
	check_victory()

func add_wall():
	walls += 1
	check_victory()

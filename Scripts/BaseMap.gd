extends Node2D


var chips_needed = 1
var walls_needed = 1

var chips = 0
var walls = 0

var next_scene = "res://Screens/Win.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("add_chip", self, "add_chip")
	Global.connect("add_wall_count", self, "add_wall")

func update_ui():
	Global.emit_signal("reset_chip", chips_needed)
	Global.emit_signal("reset_wall_count", walls_needed)

func check_victory():
	if chips >= chips_needed and walls >= walls_needed:
		Global.goto_scene(next_scene)

func add_chip():
	chips += 1
	check_victory()

func add_wall():
	walls += 1
	check_victory()

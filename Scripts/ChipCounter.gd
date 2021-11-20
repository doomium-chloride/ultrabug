extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_chips = 0
var total_chips = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	set_label()
	Global.connect("reset_chip", self, "reset_label")
	Global.connect("add_chip", self, "add_chip")

func reset_label(chips):
	current_chips = 0
	total_chips = chips
	set_label()

func add_chip():
	current_chips += 1
	set_label()

func set_label():
	var text = "%d / %d" % [current_chips, total_chips]
	$Label.text = text

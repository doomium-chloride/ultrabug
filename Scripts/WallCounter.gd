extends Control


var current_count = 0
var max_count = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	set_label()
	Global.connect("add_wall_count", self, "add_count")
	Global.connect("reset_wall_count", self, "reset")

func reset(num):
	current_count = 0
	max_count = num
	set_label()

func add_count():
	current_count += 1
	set_label()

func set_label():
	var text = "%d / %d" % [current_count, max_count]
	$Label.text = text

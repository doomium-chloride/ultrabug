extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("time", self, "update_time")


func update_time(time):
	var string = time2str(time)
	$Label.text = string

func time2str(time):
	return "%07.2f" % time

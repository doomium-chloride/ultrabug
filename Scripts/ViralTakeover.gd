extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var max_size = 10
var current_size = 1
var grow_time_spam = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func grow(delta):
	current_size += delta * max_size / grow_time_spam
	scale.x = current_size
	scale.y = current_size
	return current_size > max_size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var reached_max_size = grow(delta)
	if reached_max_size:
		queue_free()



func _on_ViralTakeover_body_entered(body):
	if body == null:
		return
	if body.has_method("take_over"):
		body.take_over()


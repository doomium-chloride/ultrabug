extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var delay = 2
const max_progress = 100
var current_progress = 0
var blink_visible = false
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureProgress.max_value = max_progress * delay
	visible = false

#updates delay
func set_delay(new_delay):
	delay = new_delay
	$TextureProgress.max_value = max_progress * delay

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_progress <= 0:
		visible = false
	elif current_progress >= $TextureProgress.max_value:
		visible = blink_visible
	else:
		visible = true
	
	if active and current_progress < $TextureProgress.max_value:
		current_progress += delta * max_progress
		
	$TextureProgress.value = current_progress
	
func activate():
	current_progress = 0
	active = true

func reset():
	current_progress = 0
	active = false
	
func release():
	var finished = current_progress >= $TextureProgress.max_value
	reset()
	return finished

func _on_Blink_timeout():
	blink_visible = not blink_visible

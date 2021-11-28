extends Area2D


const is_chip = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.get("is_player") == true:
		pickup()

func pickup():
	Global.emit_signal("add_chip")
	$AudioStreamPlayer.play()
	visible = false
	collision_layer = 0
	collision_mask = 0

func _on_AudioStreamPlayer_finished():
	queue_free()
	visible = false

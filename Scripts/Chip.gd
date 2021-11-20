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
		Global.emit_signal("add_chip")
		queue_free()

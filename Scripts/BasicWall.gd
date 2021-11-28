extends StaticBody2D

const is_wall = true
var max_hp = 2
var hp = max_hp

# Called when the node enters the scene tree for the first time.
func _ready():
	hp = max_hp


func take_dmg(dmg, origin = null):
	hp -= dmg
	if dmg <= max_hp/2:
		$Sprite.animation = "broken"
	if hp <= 0:
		destroy_self()

func destroy_self():
	$DestroySound.play()
	Global.emit_signal("add_wall_count")
	visible = false
	collision_layer = 0
	collision_mask = 0


func _on_DestroySound_finished():
	queue_free()

extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 1000
var direction = Vector2.ZERO
var origin = null
var dmg = 1
var bounces = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	translate(direction * speed * delta)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()



func _on_Bullet_body_entered(body):
	if body == origin:
		return
	if body == null:
		return
	if body.has_method("take_dmg") and body.get("taken_over") != true:
		body.take_dmg(dmg, origin)
		queue_free()

func bounce(collision):
	bounces -= 1
	if bounces <= 0:
		queue_free()
	
	var normal = collision.normal
	if abs(normal.x) > abs(normal.y):
		direction.x *= -1
	elif abs(normal.x) < abs(normal.y):
		direction.y *= -1
	else:
		direction *= -1

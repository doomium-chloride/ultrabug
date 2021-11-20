extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 1000
var direction = Vector2.ZERO
var origin = null
var dmg = 1
var bounces = 10
var bounce_cooldown = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	move_and_slide(direction * speed)
	process_collisions()


func process_collisions():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		bounce(collision)


func bounce(collision):
	if bounce_cooldown:
		return
	bounces -= 1
	if bounces <= 0:
		queue_free()
	
	var normal = collision.normal
	if abs(normal.x) > abs(normal.y):
		direction.x *= -1
	if abs(normal.x) < abs(normal.y):
		direction.y *= -1
	
	if collision.collider.has_method("take_dmg"):
		collision.collider.take_dmg(dmg)
		
	bounce_cooldown = true
	$BounceCooldown.start()


func _on_Timer_timeout():
	set_collision_layer_bit(0, true)
	set_collision_mask_bit(0, true)


func _on_BounceCooldown_timeout():
	bounce_cooldown = false

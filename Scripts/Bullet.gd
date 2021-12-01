extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 800
var direction = Vector2.ZERO
var origin = null
var dmg = 1
var bounces = 10
var bounce_cooldown = false
var has_bounced = false
var is_bullet = true

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("clean_up", self, "clear_self")

func _physics_process(delta):
	move_and_slide(direction * speed)
	process_collisions()


func process_collisions():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		bounce(collision)

func clear_self():
	if is_instance_valid(self):
		queue_free()

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
	var jiggled_direction = Global.jiggle_vector2(direction)
	direction.x = jiggled_direction.x
	direction.y = jiggled_direction.y
	
	if  is_instance_valid(collision.collider) and collision.collider.has_method("take_dmg"):
#		if collision.collider.get("is_player") == true:
#			if not collision.collider.shield_on:
#				clear_self()
		if has_bounced:
			collision.collider.take_dmg(dmg)
		else:
			collision.collider.take_dmg(dmg, origin)
			
	has_bounced = true
	bounce_cooldown = true
	$BounceCooldown.start()


func _on_Timer_timeout():
	#set_collision_layer_bit(0, true)
	set_collision_mask_bit(0, true)


func _on_BounceCooldown_timeout():
	bounce_cooldown = false

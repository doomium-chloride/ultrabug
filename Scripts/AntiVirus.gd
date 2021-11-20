extends KinematicBody2D


export var direction = Vector2()
var speed = 100
var max_hp = 10
var hp = max_hp
var low_hp = max_hp/2
var taken_over = false
var target = null
var stuttering = false
var stutter_flip = false
var chase_boost = 4


# Called when the node enters the scene tree for the first time.
func _ready():
	hp = max_hp

func _process(delta):
	if stuttering:
		stutter_effect()
	if taken_over:
		if target != null:
			if target.get("taken_over") == true:
				target = null

func _physics_process(delta):
	$RedDot.visible = false
	var current_speed = speed
	if Global.lag:
		if Global.chance(0.8):
			current_speed = 0
	if target != null and can_see_target():
		look_at(target.position)
		var velocity = Vector2(current_speed * chase_boost, 0).rotated(rotation)
		move_and_slide(velocity)
		$RedDot.visible = true
	else:
		lose_aggro()
		move_and_slide(direction.normalized() * current_speed)
		process_collisions()


func process_collisions():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.get("is_wall") == true:
			bounce(collision)


func bounce(collision):
	var normal = collision.normal
	if abs(normal.x) > abs(normal.y):
		direction.x *= -1
	elif abs(normal.x) < abs(normal.y):
		direction.y *= -1
	else:
		direction *= -1

func take_dmg(dmg, origin = null):
	hp -= dmg
	if hp <= low_hp && dmg:
		stuttering = true
	if hp <= 0:
		queue_free()
	else:
		$AudioStreamPlayer.play()
	if origin != null:
		if origin.get("is_player") == true:
			target = origin

func take_over():
	if hp <= low_hp:
		taken_over = true
		target = null
		$AnimatedSprite.animation = "takenOver"
		stuttering = false
		$AnimatedSprite.modulate = Color(1,1,1)


func _on_Sight_body_entered(body):
	if taken_over:
		if body.get("taken_over") == false:
			target = body
	else:
		if body.get("is_player") == true:
			target = body
		elif body.get("taken_over") == true:
			target = body

func stutter_effect():
	if stutter_flip:
		$AnimatedSprite.modulate = Color(0.5,0.5,0.5)
	else:
		$AnimatedSprite.modulate = Color(2,2,2)
	stutter_flip = not stutter_flip
	
func can_see_target():
	if target == null:
		return false
	var space_state = get_world_2d().direct_space_state
	var centre = target.position
	var result = space_state.intersect_ray(position, centre, [self], collision_layer)
	return result.collider == target and target != null

func lose_aggro():
	if target == null:
		return
	if not can_see_target():
		target = null

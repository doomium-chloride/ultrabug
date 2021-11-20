extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const bullet_class = preload("res://Actors/Bullet.tscn")
const viral_takeover_class = preload("res://Actors/ViralTakeover.tscn")
var speed = 600
const is_player = true
var last_direction = Global.direction.right
var was_right = true

const weapons = [
	"hijack",
	"lag"
]

var current_weapon = 0
var main_cooldown = false
var high_power_shoot = false

# Called when the node enters the scene tree for the first time.
func _ready():
	cycle_weapon(0)
	Global.connect("ready_weapon", self, "cycle_weapon", [0])
	Global.connect("enable_shoot", self, "enable_shoot")
	Global.connect("high_power_shoot", self, "on_HPS_change")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var move_vec = Vector2()
	if Input.is_action_pressed("ui_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("ui_right"):
		move_vec.x += 1
	if Input.is_action_pressed("ui_up"):
		move_vec.y -= 1
	if Input.is_action_pressed("ui_down"):
		move_vec.y += 1
	var velocity = move_and_slide(move_vec.normalized() * speed)
	var direction = get_last_direction(velocity)
	control_anim(direction, velocity)
	#face_mouse()

func _input(event):
	if event.is_action_pressed("click_left"):
		if not main_cooldown:
			shoot_bullet(get_mouse_pos())
			Global.emit_signal("reset_power_gauge")
			main_cooldown = true
	if event.is_action_pressed("click_right"):
		$PowerCircle.activate()
	if event.is_action_released("click_right"):
		var success = $PowerCircle.release()
		if success:
			use_weapon(get_mouse_pos())
	if event.is_action_pressed("next_weapon"):
		cycle_weapon(1)
	if event.is_action_pressed("prev_weapon"):
		cycle_weapon(-1)


func shoot_bullet(pos):
	
	var direction = get_direction(pos)
	var bullet = bullet_class.instance()
	bullet.origin = self
	bullet.position = position
	bullet.direction = direction
	if high_power_shoot:
		bullet.dmg = 3
		$WeaponSound.play()
	else:
		bullet.dmg = 1
		$WeaponSoundLow.play()
	get_tree().get_root().add_child(bullet)
	
	
func viral_takeover(pos):
	var takeover = viral_takeover_class.instance()
	takeover.position = pos
	get_tree().get_root().add_child(takeover)

func get_direction(pos):
	return (pos - position).normalized()

func face_mouse():
	var mouse_pos = get_mouse_pos()
	look_at(mouse_pos)
	if mouse_pos != position:
		rotation += PI/2
	$PowerCircle.set_rotation(-rotation)

func cycle_weapon(steps):
	var num_of_weapons = len(weapons)
	var index = (current_weapon + steps) % num_of_weapons
	current_weapon = index
	Global.emit_signal("change_weapon", weapons[index])

func use_weapon(pos):
	if current_weapon == 0:
		viral_takeover(pos)
	elif current_weapon == 1:
		if not Global.lag:
			Global.emit_signal("start_lag")
			$LagTimer.start()

func enable_shoot():
	main_cooldown = false

func on_HPS_change(state):
	high_power_shoot = state

func get_mouse_pos():
	return get_viewport().get_mouse_position() + position - get_viewport().size/2


func _on_LagTimer_timeout():
	Global.emit_signal("end_lag")

func get_last_direction(velocity):
	if velocity.length() == 0:
		return last_direction
	var current_direction;
	if velocity.x > 0:
		current_direction = Global.direction.right
	elif velocity.x < 0:
		current_direction = Global.direction.left
	elif velocity.y > 0:
		current_direction = Global.direction.down
	else:
		current_direction = Global.direction.up
	last_direction = current_direction
	return current_direction

func control_anim(direction, velocity):
	var is_moving = velocity.length() > 0
	if is_moving:
		match direction:
			Global.direction.right:
				$AnimatedSprite.flip_h = false
				$AnimatedSprite.animation = "walk-right"
				was_right = true
			Global.direction.left:
				$AnimatedSprite.flip_h = true
				$AnimatedSprite.animation = "walk-right"
				was_right = false
			Global.direction.down:
				$AnimatedSprite.flip_h = not was_right
				$AnimatedSprite.animation = "walk-right"
			Global.direction.up:
				$AnimatedSprite.flip_h = not was_right
				$AnimatedSprite.animation = "walk-right"
	else:
		match direction:
			Global.direction.right:
				$AnimatedSprite.flip_h = false
				$AnimatedSprite.animation = "idle-right"
			Global.direction.left:
				$AnimatedSprite.flip_h = true
				$AnimatedSprite.animation = "idle-right"
			Global.direction.down:
				$AnimatedSprite.flip_h = not was_right
				$AnimatedSprite.animation = "idle-right"
			Global.direction.up:
				$AnimatedSprite.flip_h = not was_right
				$AnimatedSprite.animation = "idle-right"

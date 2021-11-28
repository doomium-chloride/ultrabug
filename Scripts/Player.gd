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
var max_hp = 10
var hp = max_hp
var god_mode = false

const weapons = [
	"infect",
	"lag",
	"stealth"
]

var current_weapon = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	cycle_weapon(0)
	Global.connect("ready_weapon", self, "cycle_weapon", [0])
	Global.emit_signal("set_hp", max_hp)

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

func _input(event):
	check_cheats()
	if event.is_action_pressed("click_left"):
		if $MainCooldown.is_stopped():
			shoot_bullet(get_mouse_pos())
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
	bullet.dmg = 1
	$WeaponSound.play()
	get_tree().get_root().add_child(bullet)
	$MainCooldown.start()
	
	
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
	var index = posmod((current_weapon + steps), num_of_weapons)
	current_weapon = index
	Global.emit_signal("change_weapon", weapons[index])

func use_weapon(pos):
	if current_weapon == 0:#infect
		viral_takeover(pos)
	elif current_weapon == 1:#lag
		if not Global.lag:
			Global.emit_signal("start_lag")
			$LagTimer.start()
	elif current_weapon == 2:#stealth
		if $StealthTimer.is_stopped():
			set_collision_layer_bit(0, false)
			set_collision_mask_bit(0, false)
			$AnimatedSprite.modulate.a = 0.5
			$StealthTimer.start()

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


func _on_StealthTimer_timeout():
	set_collision_layer_bit(0, true)
	set_collision_mask_bit(0, true)
	$AnimatedSprite.modulate.a = 1

func take_dmg(dmg, origin = null):
	if god_mode:
		return
	hp -= dmg
	Global.emit_signal("update_hp", hp)
	if hp <= 0:
		Global.emit_signal("clean_up")
		Global.goto_scene("res://Screens/Lose.tscn")
	else:
		$HitSound.play()

func check_cheats():
	if Input.is_action_pressed("god_mode"):
		god_mode = true
	elif Input.is_action_pressed("collision_off"):
		collision_mask = 0
		collision_layer = 0
	elif Input.is_action_pressed("get_chips"):
		Global.emit_signal("add_chip")

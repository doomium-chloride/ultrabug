extends TextureProgress

const border_off = preload("res://Assets/UI/PowerGauge/border-off.png")
const border_on = preload("res://Assets/UI/PowerGauge/border-on.png")

const half = 50
var fill_speed = 50
var cooldown = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("reset_power_gauge", self, "reset_gauge")


func _physics_process(delta):
	cycle_value(delta)
	update_texture()
	
func cycle_value(delta):
	if cooldown:
		if value != min_value:
			value = min_value
		return
	if value >= max_value:
		value = min_value
	else:
		value += delta * fill_speed
	
func update_texture():
	if value >= half and texture_over != border_on:
		texture_over = border_on
		Global.emit_signal("high_power_shoot", true)
	elif value < half and texture_over != border_off:
		texture_over = border_off
		Global.emit_signal("high_power_shoot", false)

func reset_gauge():
	cooldown = true
	$Timer.start()
	Global.emit_signal("high_power_shoot", false)


func _on_Timer_timeout():
	cooldown = false
	Global.emit_signal("enable_shoot")

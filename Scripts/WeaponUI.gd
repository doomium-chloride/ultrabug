extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("change_weapon", self, "update_weapon_text")
	Global.emit_signal("ready_weapon")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func update_weapon_text(txt):
	text = txt

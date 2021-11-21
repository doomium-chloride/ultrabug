extends TextureProgress



# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("set_hp", self, "set_hp")
	Global.connect("update_hp", self, "update_hp")


func set_hp(hp):
	max_value = hp
	update_hp(hp)

func update_hp(hp):
	value = hp


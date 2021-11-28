extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PlayButton_pressed():
	Global.goto_scene("res://Screens/intro.tscn")


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_Tutorial_pressed():
	Global.emit_signal("reset_time")
	Global.goto_scene("res://Screens/How2Play.tscn")


func _on_CreditsButton_pressed():
	Global.goto_scene("res://Screens/Credits.tscn")

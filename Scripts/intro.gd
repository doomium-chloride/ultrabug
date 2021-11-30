extends Control

var skip_visibility = false

func _input(event):
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("ui_accept"):
		skip_visibility = not skip_visibility
		$Skip.visible = skip_visibility


func _on_AtLongLast_finished():
	$Voices/Lightswitch.play()
	$Images/Bug1.visible = true
	$Images/ColorRect.visible = false
	$Music.play()

func _on_Lightswitch_finished():
	$Timers/LightPause.start()

func _on_LightPause_timeout():
	$Voices/TheUltimate.play()
	$Images/Bug2.visible = true
	$Images/Bug1.visible = false

func _on_TheUltimate_finished():
	$Voices/SuperBug.play()
	$Images/Super.visible = true
	$Images/Bug2.visible = false

func _on_SuperBug_finished():
	$Voices/Brick.play()
	$Images/Upload.visible = true
	$Images/Super.visible = false

func _on_Brick_finished():
	start_game()
	
func start_game():
	Global.emit_signal("reset_time")
	Global.goto_scene("res://Maps/TestLevel.tscn")


func _on_No_pressed():
	skip_visibility = false
	$Skip.visible = false

func _on_Yes_pressed():
	start_game()

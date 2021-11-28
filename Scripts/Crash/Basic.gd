extends Control


var BasicWindow_Class = preload("res://Screens/crash/Component/BasicWIndow.tscn")

var pixels = 10
var pos = rect_position
export var num_of_windows = 20
var windows = 1
onready var last_window = $Windows/BasicWindow

func update_pos():
	pos.x += pixels
	pos.y += pixels

func stop_last_window_audio(current_window):
	last_window.stop_audio()
	last_window = current_window

func spawn_new_window():
	update_pos()
	var window = BasicWindow_Class.instance()
	window.rect_position = pos
	window.disabled = windows < num_of_windows
	stop_last_window_audio(window)
	$Windows.add_child(window)
	windows += 1

func _on_InitialTimer_timeout():
	$SpamTimer.start()


func _on_SpamTimer_timeout():
	spawn_new_window()
	if windows <= num_of_windows:
		$SpamTimer.start()

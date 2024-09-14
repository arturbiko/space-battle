extends Node2D

signal restart_pressed()
signal menu_pressed()

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_R):
		emit_signal("restart_pressed")
	
	if Input.is_key_pressed(KEY_M):
		emit_signal("menu_pressed")

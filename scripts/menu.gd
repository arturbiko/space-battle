extends Node

signal play_pressed()
signal exit_pressed()

func _on_play_pressed() -> void:
	emit_signal("play_pressed")

func _on_exit_pressed() -> void:
	emit_signal("exit_pressed")

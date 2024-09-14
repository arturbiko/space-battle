extends Node2D

@onready var MenuScene: PackedScene = preload("res://menu.tscn")
@onready var LevelScene: PackedScene = preload("res://level.tscn")
@onready var GameOverScene: PackedScene = preload("res://game_over.tscn")

func _ready() -> void:
	self.instantiate_menu()
	
func _on_play_pressed() -> void:
	remove_child($MenuScene)
	instatiate_level()

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_restart_pressed() -> void:
	remove_child($GameOver)
	instatiate_level()
		
func _on_menu_pressed() -> void:
	remove_child($GameOver)
	instantiate_menu()

func _on_game_over() -> void:
	call_deferred("remove_child", $Level)
	instantiate_game_over()

func instantiate_menu() -> void:
	var menu = MenuScene.instantiate()
	menu.connect("play_pressed", _on_play_pressed)
	menu.connect("exit_pressed", _on_exit_pressed)
	add_child(menu)
	
func instantiate_game_over() -> void:
	var scene = GameOverScene.instantiate()
	scene.restart_pressed.connect(_on_restart_pressed)
	scene.menu_pressed.connect(_on_menu_pressed)
	add_child(scene)
	
func  instatiate_level() -> void:
	var level = LevelScene.instantiate()
	level.game_over.connect(_on_game_over)
	add_child(level)
